package main

import (
	"fmt"
	"math/rand"
	"strconv"
	"strings"
)

func main() {
	nums := []string{}
	for i := 0; i < 63; i++ {
		str := strconv.Itoa(i)
		nums = append(nums, str)
		nums = append(nums, str)
		nums = append(nums, str)
		nums = append(nums, str)
	}

	// Extra hellbombs :D
	nums = append(nums, "58")
	nums = append(nums, "58")
	nums = append(nums, "58")
	nums = append(nums, "58")

	for x := 0; x < 2; x++ {
		rand.Shuffle(len(nums), func(i, j int) {
			nums[i], nums[j] = nums[j], nums[i]
		})
	}

	fmt.Println(".byte " + strings.Join(nums, ", "))
}
