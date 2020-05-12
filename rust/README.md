# Rust

Wrap an error with a string view of a static string. Remove `'static` to pass dynamically allocated strings.
```rust
trait Wrap<T> {
    fn wrap(self, v: &'static str) -> Result<T, Box<dyn Error>>;
}

impl<T, E> Wrap<T> for Result<T, E>
    where E: Error
{
    fn wrap(self, value: &'static str) -> Result<T, Box<dyn Error>> {
        self.map_err(|x| format!("{}: {}", &value, x).into())
    }
}

fn read_header(header_len: usize) -> Result<String, Box<dyn Error>> {
    let mut file = stdfs::File::open("file.txt").wrap("fail to open the file")?;
    let mut buf = vec![0u8; header_len];
    file.read(&mut buf).wrap("fail to read a file")?;
    String::from_utf8(buf).wrap("fail to convert file data into UTF-8 string")
}
```

Extend Option and Result types with `or_exit` method
```rust
trait Exit<T> {
    fn or_exit(self, msg: &str) -> T;
}

impl<T, E> Exit<T> for Result<T, E> {
    fn or_exit(self, msg: &str) -> T {
        if let Ok(x) = self {
            return x;
        }
        println!("{}", msg);
        exit(1);
    }
}

impl<T> Exit<T> for Option<T> {
    fn or_exit(self, msg: &str) -> T {
        if self.is_some() {
            return self.unwrap();
        }
        println!("{}", msg);
        exit(1);
    }
}
```

## Compile-time checked state machine
All transitions between states are checked in compile-time. Weak spot happens if stateful objects are in a collection.
They should have the same size which is known in compile time.

```rust
struct Receiving;
struct Sending;

trait State {
    fn receiving(&self) -> Result<Receiving, ()> {
        Err(())
    }

    fn sending(&self) -> Result<Sending, ()> {
        Err(())
    }
}

impl State for Receiving {
    fn receiving(&self) -> Result<Receiving, ()> {
        Ok(Receiving)
    }
}

impl State for Sending {
    fn sending(&self) -> Result<Sending, ()> {
        Ok(Sending)
    }
}

struct Channel<State> {
    _state: PhantomData<State>
}

impl Channel<Receiving> {
    fn recv(mut self) -> Channel<Sending> {
        unsafe { transmute(self) }
    }

    fn ping(&self) {
    }
}

impl Channel<Sending> {
    fn send(mut self, msg: String) -> (Channel<Receiving>, String) {
        (unsafe { transmute(self) }, msg)
    }

    fn ping(&self) {
    }
}

type ChannelPtr = (Channel<()>, Box<dyn State>);

impl Into<ChannelPtr> for Channel<Sending> {
    fn into(self) -> ChannelPtr {
        (Channel{ _state: PhantomData}, Box::new(Sending))
    }
}

impl Into<ChannelPtr> for Channel<Receiving> {
    fn into(self) -> ChannelPtr {
        (Channel{ _state: PhantomData}, Box::new(Receiving))
    }
}

fn main() {
    let mut ch1 = Channel::<Sending>{_state: PhantomData};
    let (mut ch1, _) = ch1.send("qwe".to_string());
    let mut ch2 = Channel::<Sending>{_state: PhantomData};
    let mut chans: Vec<ChannelPtr> = vec![ch1.into(), ch2.into()];
    let (ch1ptr, state) = chans.pop().unwrap();
    if state.receiving().is_ok() {
        let ch1 = Channel::<Receiving>{_state: PhantomData};
    }
}

```
