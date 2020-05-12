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
