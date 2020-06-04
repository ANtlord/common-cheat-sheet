# Rust

Wrap an error with a string view of a static string. Remove `'static` to pass dynamically allocated strings.
```rust
trait Wrap<T> {
    fn wrap(self, v: &'static str) -> Result<T, Box<dyn Error>>;
}

impl<T, E> Wrap<T> for Result<T, E>
    where E: Into<Box<dyn Error>> // to cover the trait bounded objects as well as trait objects.
{
    fn wrap(self, value: &'static str) -> Result<T, Box<dyn Error>> {
        self.map_err(|x| format!("{}: {}", &value, x.into()).into())
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

Impl limitation. If a structure holds some reference with a certain lifetime then it's impossible
to have a method which returns `impl Trait` because the compiler can't infer proper lifetime. It raises
```hidden type for `impl Trait` captures lifetime that does not appear in bounds```
Return an arbitrary type instead of `impl Trait`. (Thread)[https://users.rust-lang.org/t/future-lifetime-bounds/43664/3]

```rust
trait Empty {
    fn empty(&mut self);
}

struct Void(u8);
struct VoidGet<'inner>(&'inner mut Void);
struct VoidGetWrap<'a, 'b>(&'a mut VoidGet<'b>);

impl<'a, 'b> Empty for VoidGetWrap<'a, 'b> {
     fn empty(&mut self) {
         let ref mut vg = self.0;
         let ref mut v = vg.0;
         v.0 = 0;
     }
}

impl<'inner> VoidGet<'inner> {
    fn wrap_self<'this>(&'this mut self) -> VoidGetWrap<'this, 'inner> {
        VoidGetWrap(self)
    }

    // doesn't compile
    // fn wrap_self<'this>(&'this mut self) -> impl Empty {
    //     VoidGetWrap(self)
    // }
}
```

As a consequence you can't return `impl FnMut`. If you need it then you need to make a function which return the `FnMut`,
the function expects a trait which your structure implements. The structure's lifetimes are hidden and compiler doesn't
care about them.

```rust
trait Inc {
    fn inc(&mut self);
}

impl<'inner> Inc for VoidGet<'inner> {
    fn inc(&mut self) {
        let ref mut v = self.0;
        v.0 += 1;
    }
}

fn inc_lazy<'a>(i: &'a mut impl Inc) -> impl FnMut() + '_ {
    move || i.inc()
}

impl<'inner> VoidGet<'inner> {
    // doesn't work
    // fn inc_lazy<'this>(&'this mut self) -> impl FnMut() + 'this {
    //     move || {
    //         let ref mut v = self.0;
    //         v.0 += 1;
    //     }
    // }
}
```
