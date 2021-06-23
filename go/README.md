# dump hex
fmt.Printf("%#02x", bytes)

# randoms

```
rand.Seed(time.Now().UnixNano())
rand.Float64() // [0; 1)
rand.Int31n(n) // [0; n)
```

