# Fan in / Fan out concurrency pattern

A producer gives tasks to workers. A consumer collects the workers' work results and passes further.

```rust
struct Process {
    counter: u8,
}

impl Process {
    fn new() -> Self {
        Self{
            counter: 0,
        }
    }

    fn step(&mut self) {
        self.counter += 1
    }

    fn is_done(&self) -> bool {
        self.counter == 5
    }
}

fn worker(name: &str, tx: SyncSender<()>) {
    for i in 0 .. 5 {
        if tx.send(()).is_err() {
            println!("worker stopped: {}", name);
            return
        }
        println!("gen item from {}", name);
    }
}

fn create_worker(name: &'static str, tx: SyncSender<()>) -> thread::JoinHandle<()> {
    thread::spawn(move || worker(name, tx))
}

fn handle(rx: Receiver<()>) {
    let mut p = Process::new();
    while !p.is_done() {
        match rx.recv() {
            Ok(_) => {
                println!("pop item");
                p.step();
            }
            Err(x) => {
                println!("Unexpected err {}. Handler stops", x);
                return
            }
        }
    }
    println!("process done")
}

fn main() {
    let (tx, rx) = sync_channel::<()>(1);
    let mut w1 = create_worker("w1", tx.clone());
    let mut w2 = create_worker("w2", tx);
    handle(rx);
    w1.join();
    w2.join();
    println!("exit");
}
```
