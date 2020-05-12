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
