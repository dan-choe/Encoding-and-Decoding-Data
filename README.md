# Encoding-and-Decoding-Data

This is a basic **accembly programming** for encoding and decoding given data.

Encoding reads the input string and count the repeated characters which length is more than 4.
If the length of repeated characters is less than 4, it does not encode.
It uses a special flag symbol in the set !#$%^&* that indicates a run, and the number is the length of the run.
The flag symbol could be different. It is depends on how you set the symbol when you call the function with data, But the symbol must be in the set !#$%^&*.
If the symbol is not in the set, it returns error message or -1.

As example, the input string is aaabcccccccddddddddddddddddEEEEEEFFFFGG. The string would be encoded as aaab$c7$d16$E6$F4GG

Decoding decodes the given encoded data with same rules of encoding. 

As example, the input encoded string is aaab$c7$d16$E6$F4GG, it would be decoded as aaabcccccccddddddddddddddddEEEEEEFFFFGG

## License

    Copyright [2016] [Dan Choe]
