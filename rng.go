package main

import (
	"fmt"
	"os"
	"math/rand"
	"strconv"
	"strings"
)

func main() {
	nums := make([]string, 64)
	for i := 0; i < len(nums)-1; i++ {
		nums[i] = strconv.Itoa(i)
	}
	nums[63] = "58"

	rand.Shuffle(len(nums), func(i, j int) {
		nums[i], nums[j] = nums[j], nums[i]
	})

	err := os.WriteFile("strats.rng.inc", []byte(".byte " + strings.Join(nums, ", ")+"\n"), 0666)
	if err != nil {
		fmt.Println("Error writing rng file:", err)
		os.Exit(1)
	}
}
