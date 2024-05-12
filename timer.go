package main

import (
	"fmt"
	"strconv"
	"strings"
)

func main() {
	rows := []string{}
	for i := 0; i < 25; i++{
		for y := 7; y >= 0; y-- {
			nums := []int{}
			for x := 0; x < i; x++{
				nums = append(nums, 0)
			}
			nums = append(nums, y)
			for x := 24; x > i; x-- {
				nums = append(nums, 8)
			}

			str := make([]string, 25)
			for i := 0; i < 25; i ++ {
				str[i] = strconv.Itoa(nums[i]+0x80)
			}

			rows = append(rows, fmt.Sprintf(".byte %s", strings.Join(str, ", ")))
		}
	}

	for i := len(rows)-1; i >= 0; i-- {
		fmt.Println(rows[i])
	}
}
