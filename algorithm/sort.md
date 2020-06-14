```go
func swap(q []int32, a, b int) {
	c := q[a]
	q[a] = q[b]
	q[b] = c
}

func partition(arr []int32) int {
	arrlen := len(arr)
	pivot := arr[arrlen - 1]
	j := -1
	for i, el := range arr {
		if el < pivot {
			j++
			swap(arr, i, j)
		}
	}

	swap(arr, j + 1, arrlen - 1)
	return j + 1
}

func quicksort(arr []int32) {
	if len(arr) < 2 {
		return
	}

	n := partition(arr)
	quicksort(arr[:n])
	quicksort(arr[n:])
}

func mergesort(arr []int32) {
	if len(arr) < 2 {
		return
	}

	n := len(arr) / 2
	left := arr[:n]
	right := arr[n:]
	mergesort(left)
	mergesort(right)
	
	tmparr := make([]int32, len(arr))
	copy(tmparr, arr)
	left = tmparr[:n]
	right = tmparr[n:]
	leftIndex := 0
	rightIndex := 0
	for i := range arr {
		if leftIndex == len(left) {
			arr[i] = right[rightIndex]
			rightIndex++
			continue
		}

		if rightIndex == len(right) {
			arr[i] = left[leftIndex]
			leftIndex++
			continue
		}

		if left[leftIndex] < right[rightIndex] {
			arr[i] = left[leftIndex]
			leftIndex++
		} else {
			arr[i] = right[rightIndex]
			rightIndex++
		}
	}
}

func bubblesort(arr []int32) {
	arrlen := len(arr)
	for i := 0; i < arrlen - 1; i++ {
		for j := 0; j < arrlen - i - 1; j++ {
			left := arr[j]
			right := arr[j + 1]
			if left > right {
				swap(arr, j, j + 1)
			}
		}
	}
}
```
