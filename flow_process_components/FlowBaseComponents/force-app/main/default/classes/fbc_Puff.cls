//
//Copyright (c) 2015 Pedro Dal Col, Pliny Smith
//
//fbc_Puff.cls based on Mark Adler's puff.c
//
public class fbc_Puff {
    private final Integer MAXBITS = 15;             /* maximum bits in a code */
    private final Integer MAXLCODES = 286;           /* maximum number of literal/length codes */
    private final Integer MAXDCODES = 30;            /* maximum number of distance codes */
    private final Integer MAXCODES = (MAXLCODES+MAXDCODES);  /* maximum codes lengths to read */
    private final Integer FIXLCODES = 288;           /* number of fixed literal/length codes */

    private Integer[] getIntArray(Integer size){

        return (Integer[]) JSON.deserialize('['+'0'.repeat(',',size) +']', Integer[].class);
    }

    private Integer[] removeNElems(Integer[] arr, Integer n){
        Integer[] newArr = new List<Integer>(arr);

        for(Integer i = 0; i<n; i++){
            newArr.remove(0);
        }

        return newArr;
    }

    ///* input and output state */
    private class State {
        /* output state */
        public String out;         /* output buffer */
        public Integer outlen;       /* available space at out */
        public Integer outcnt;       /* bytes written to out so far */

        /* input state */
        public String inStr;    /* input buffer */
        public Integer inlen;        /* available input at in */
        public Integer incnt;        /* bytes read so far */
        public Integer bitbuf;                 /* bit buffer */
        public Integer bitcnt;                 /* number of bits in bit buffer */

    }

    /*
     * Return need bits from the input stream.  This always leaves less than
     * eight bits in the buffer.  bits() works properly for need == 0.
     *
     * Format notes:
     *
     * - Bits are stored in bytes from the least significant bit to the most
     *   significant bit.  Therefore bits are dropped from the bottom of the bit
     *   buffer, using shift right, and new bytes are appended to the top of the
     *   bit buffer, using shift left.
     */
    private Integer bits(State s, Integer need)
    {
        Long val;           /* bit accumulator (can use up to 20 bits) */
        Integer incnt2;
        ///* load at least need bits into val */
        val = s.bitbuf;
        while (s.bitcnt < need) {
            incnt2 = s.incnt++ *2;
            val |= (((s.inStr.charAt(incnt2) & 15)+(s.inStr.charAt(incnt2)>>>6)*9) * 16
                | (s.inStr.charAt(incnt2+1) & 15)+(s.inStr.charAt(incnt2+1)>>>6) * 9) << s.bitcnt;
            
            s.bitcnt += 8;
        }

        ///* drop need bits and update buffer, always zero to seven bits left */
        s.bitbuf = (Integer)(val >>> need);
        s.bitcnt -= need;

        ///* return need bits, zeroing the bits above that */
        return (Integer)(val & ((1L << need) - 1));
    }

    private Long hexToLong (String hexStr){
        return ((hexStr.charAt(0) & 15)+(hexStr.charAt(0)>>>6)*9) * 16
              + (hexStr.charAt(1) & 15)+(hexStr.charAt(1)>>>6) * 9;
    }

    /*
     * Process a stored block.
     *
     * Format notes:
     *
     * - After the two-bit stored block type (00), the stored block length and
     *   stored bytes are byte-aligned for fast copying.  Therefore any leftover
     *   bits in the byte that has the last bit of the type, as many as seven, are
     *   discarded.  The value of the discarded bits are not defined and should not
     *   be checked against any expectation.
     *
     * - The second inverted copy of the stored block length does not have to be
     *   checked, but it's probably a good idea to do so anyway.
     *
     * - A stored block can have zero length.  This is sometimes used to byte-align
     *   subsets of the compressed data for random access or partial recovery.
     */
    private Integer stored(State s)
    {
        Integer len;       /* length of stored block */

        /* discard leftover bits from current byte (assumes s->bitcnt < 8) */
        s.bitbuf = 0;
        s.bitcnt = 0;

        /* get length and check against its one's complement */
        if (s.incnt + 4 > s.inlen)
            return 2;                               /* not enough input */
        len = (Integer)hexToLong(s.inStr.mid(s.incnt++ *2, 2));
        len |= (Integer)hexToLong(s.inStr.mid(s.incnt++ *2, 2)) << 8;
        s.incnt++;
        s.incnt++;
        
        /* copy len bytes from in to out */
        while (len-- != 0) {
            s.out += s.inStr.mid(s.incnt++ *2, 2);
            s.outcnt++;
            //s.out[s.outcnt++] = s.inStr[s.incnt++];
        }

        /* done with a valid stored block */
        return 0;
    }

    /*
     * Huffman code decoding tables.  count[1..MAXBITS] is the number of symbols of
     * each length, which for a canonical code are stepped through in order.
     * symbol[] are the symbol values in canonical order, where the number of
     * entries is the sum of the counts in count[].  The decoding process can be
     * seen in the function decode() below.
     */
    public class Huffman {
        List<Integer> count;        //number of symbols of each length 
        List<Integer> symbol;      /* canonically ordered symbols */
    }

    /*
     * Decode a code from the stream s using huffman table h.  Return the symbol or
     * a negative value if there is an error.  If all of the lengths are zero, i.e.
     * an empty code, or if the code is incomplete and an invalid code is received,
     * then -10 is returned after reading MAXBITS bits.
     *
     * Format notes:
     *
     * - The codes as stored in the compressed data are bit-reversed relative to
     *   a simple integer ordering of codes of the same lengths.  Hence below the
     *   bits are pulled from the compressed data one at a time and used to
     *   build the code value reversed from what is in the stream in order to
     *   permit simple integer comparisons for decoding.  A table-based decoding
     *   scheme (as used in zlib) does not need to do this reversal.
     *
     * - The first code for the shortest length is all zeros.  Subsequent codes of
     *   the same length are simply integer increments of the previous code.  When
     *   moving up a length, a zero bit is appended to the code.  For a complete
     *   code, the last code of the longest length will be all ones.
     *
     * - Incomplete codes are handled by this decoder, since they are permitted
     *   in the deflate format.  See the format notes for fixed() and dynamic().
     */
    //#ifdef SLOW
    //private Integer decodeSlow(State s, Huffman h) //Slow
    //{
    //    //System.debug('called decode slow()');

    //    Integer len;            /* current number of bits in code */
    //    Integer code;           /* len bits being decoded */
    //    Integer first;          /* first code of length len */
    //    Integer count;          /* number of codes of length len */
    //    Integer index;          /* index of first code of length len in symbol table */

    //    code = first = index = 0;
    //    for (len = 1; len <= MAXBITS; len++) {
    //        code |= bits(s, 1);             /* get next bit */
    //        count = h.count[len];
    //        if (code - count < first)       /* if length len, return symbol */
    //            return h.symbol[index + (code - first)];
    //        index += count;                 /* else update for next length */
    //        first += count;
    //        first <<= 1;
    //        code <<= 1;
    //    }
    //    return -10;                         /* ran out of codes */
    //}
    
    /*
     * A faster version of decode() for real applications of this code.   It's not
     * as readable, but it makes puff() twice as fast.  And it only makes the code
     * a few percent larger.
     */
    //#else /* !SLOW */
    public Integer decode(State s, Huffman h) //Fast
    {
        Integer len;            /* current number of bits in code */
        Integer code;           /* len bits being decoded */
        Integer first;          /* first code of length len */
        Integer count;          /* number of codes of length len */
        Integer index;          /* index of first code of length len in symbol table */
        Integer bitbuf;         /* bits from stream */
        Integer left;           /* bits left in next or left to process */
        Integer[] next;        /* next number of codes */

        bitbuf = s.bitbuf;
        left = s.bitcnt;
        code = first = index = 0;
        len = 1;
        next = h.count;
        while (true) {
            while (left-- != 0) {
                code |= bitbuf & 1;
                bitbuf >>>= 1;
                count = next[len];
                if (code - count < first) { /* if length len, return symbol */
                    s.bitbuf = bitbuf;
                    s.bitcnt = (s.bitcnt - len) & 7;
                    return h.symbol[index + (code - first)];
                }
                index += count;             /* else update for next length */
                first += count;
                first <<= 1;
                code <<= 1;
                len++;
            }
            left = (MAXBITS+1) - len;
            if (left == 0)
                break;
            bitbuf = (Integer)hexToLong(s.inStr.mid(s.incnt++ *2, 2));
            if (left > 8)
                left = 8;
        }
        System.assert(false, 'Ran out of codes while decompressing.');
        return -10;                         /* ran out of codes */
    }
    //#endif /* SLOW */

    /*
     * Given the list of code lengths length[0..n-1] representing a canonical
     * Huffman code for n symbols, construct the tables required to decode those
     * codes.  Those tables are the number of codes of each length, and the symbols
     * sorted by length, retaining their original order within each length.  The
     * return value is zero for a complete code set, negative for an over-
     * subscribed code set, and positive for an incomplete code set.  The tables
     * can be used if the return value is zero or positive, but they cannot be used
     * if the return value is negative.  If the return value is zero, it is not
     * possible for decode() using that table to return an error--any stream of
     * enough bits will resolve to a symbol.  If the return value is positive, then
     * it is possible for decode() using that table to return an error for received
     * codes past the end of the incomplete lengths.
     *
     * Not used by decode(), but used for error checking, h->count[0] is the number
     * of the n symbols not in the code.  So n - h->count[0] is the number of
     * codes.  This is useful for checking for incomplete codes that have more than
     * one symbol, which is an error in a dynamic block.
     *
     * Assumption: for all i in 0..n-1, 0 <= length[i] <= MAXBITS
     * This is assured by the construction of the length arrays in dynamic() and
     * fixed() and is not verified by construct().
     *
     * Format notes:
     *
     * - Permitted and expected examples of incomplete codes are one of the fixed
     *   codes and any code with a single symbol which in deflate is coded as one
     *   bit instead of zero bits.  See the format notes for fixed() and dynamic().
     *
     * - Within a given code length, the symbols are kept in ascending order for
     *   the code bits definition.
     */
    private Integer construct(Huffman h, Integer[] length, Integer n)
    {
        Integer symbol;         /* current symbol when stepping through length[] */
        Integer len;            /* current length when stepping through h->count[] */
        Integer left;           /* number of possible codes left of current length */
        Integer[] offs = getIntArray(MAXBITS+1);      /* offsets in symbol table for each length */

        /* count number of codes of each length */
        for (len = 0; len <= MAXBITS; len++)
            h.count[len] = 0;
        for (symbol = 0; symbol < n; symbol++)
            (h.count[length[symbol]])++;   /* assumes lengths are within bounds */
        if (h.count[0] == n)               /* no codes! */
            return 0;                       /* complete, but decode() will fail */

        /* check for an over-subscribed or incomplete set of lengths */
        left = 1;                            //one possible code of zero length 
        for (len = 1; len <= MAXBITS; len++) {
            left <<= 1;                     /* one more bit, double codes left */
            left -= h.count[len];          /* deduct count from possible codes */
            if (left < 0)
                return left;                /* over-subscribed--return negative */
        }                                   /* left > 0 means incomplete */

        /* generate offsets into symbol table for each length for sorting */
        offs[1] = 0;
        for (len = 1; len < MAXBITS; len++)
            offs[len + 1] = offs[len] + h.count[len];

        /*
         * put symbols in table sorted by length, by symbol order within each
         * length
         */
        for (symbol = 0; symbol < n; symbol++)
            if (length[symbol] != 0) {
                h.symbol[offs[length[symbol]]] = symbol;
                offs[length[symbol]]++;
            }

        /* return zero for complete set, positive for incomplete set */
        return left;
    }

    /*
     * Decode literal/length and distance codes until an end-of-block code.
     *
     * Format notes:
     *
     * - Compressed data that is after the block type if fixed or after the code
     *   description if dynamic is a combination of literals and length/distance
     *   pairs terminated by and end-of-block code.  Literals are simply Huffman
     *   coded bytes.  A length/distance pair is a coded length followed by a
     *   coded distance to represent a string that occurs earlier in the
     *   uncompressed data that occurs again at the current location.
     *
     * - Literals, lengths, and the end-of-block code are combined into a single
     *   code of up to 286 symbols.  They are 256 literals (0..255), 29 length
     *   symbols (257..285), and the end-of-block symbol (256).
     *
     * - There are 256 possible lengths (3..258), and so 29 symbols are not enough
     *   to represent all of those.  Lengths 3..10 and 258 are in fact represented
     *   by just a length symbol.  Lengths 11..257 are represented as a symbol and
     *   some number of extra bits that are added as an integer to the base length
     *   of the length symbol.  The number of extra bits is determined by the base
     *   length symbol.  These are in the static arrays below, lens[] for the base
     *   lengths and lext[] for the corresponding number of extra bits.
     *
     * - The reason that 258 gets its own symbol is that the longest length is used
     *   often in highly redundant files.  Note that 258 can also be coded as the
     *   base value 227 plus the maximum extra value of 31.  While a good deflate
     *   should never do this, it is not an error, and should be decoded properly.
     *
     * - If a length is decoded, including its extra bits if any, then it is
     *   followed a distance code.  There are up to 30 distance symbols.  Again
     *   there are many more possible distances (1..32768), so extra bits are added
     *   to a base value represented by the symbol.  The distances 1..4 get their
     *   own symbol, but the rest require extra bits.  The base distances and
     *   corresponding number of extra bits are below in the static arrays dist[]
     *   and dext[].
     *
     * - Literal bytes are simply written to the output.  A length/distance pair is
     *   an instruction to copy previously uncompressed bytes to the output.  The
     *   copy is from distance bytes back in the output stream, copying for length
     *   bytes.
     *
     * - Distances pointing before the beginning of the output data are not
     *   permitted.
     *
     * - Overlapped copies, where the length is greater than the distance, are
     *   allowed and common.  For example, a distance of one and a length of 258
     *   simply copies the last byte 258 times.  A distance of four and a length of
     *   twelve copies the last four bytes three times.  A simple forward copy
     *   ignoring whether the length is greater than the distance or not implements
     *   this correctly.  You should not use memcpy() since its behavior is not
     *   defined for overlapped arrays.  You should not use memmove() or bcopy()
     *   since though their behavior -is- defined for overlapping arrays, it is
     *   defined to do the wrong thing in this case.
     */
    private final Integer[] lens = new List<Integer>{ /* Size base for length codes 257..285 */
        3, 4, 5, 6, 7, 8, 9, 10, 11, 13, 15, 17, 19, 23, 27, 31,
        35, 43, 51, 59, 67, 83, 99, 115, 131, 163, 195, 227, 258};
    private final Integer[] lext = new List<Integer>{ /* Extra bits for length codes 257..285 */
        0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 2, 2, 2, 2,
        3, 3, 3, 3, 4, 4, 4, 4, 5, 5, 5, 5, 0};
    private final Integer[] dists = new List<Integer>{ /* Offset base for distance codes 0..29 */
        1, 2, 3, 4, 5, 7, 9, 13, 17, 25, 33, 49, 65, 97, 129, 193,
        257, 385, 513, 769, 1025, 1537, 2049, 3073, 4097, 6145,
        8193, 12289, 16385, 24577};
    private final Integer[] dext = new List<Integer>{ /* Extra bits for distance codes 0..29 */
        0, 0, 0, 0, 1, 1, 2, 2, 3, 3, 4, 4, 5, 5, 6, 6,
        7, 7, 8, 8, 9, 9, 10, 10, 11, 11,
        12, 12, 13, 13};

    public Integer codes(State s,
                    Huffman lencode,
                    Huffman distcode)
    {
        Integer symbol;         /* decoded symbol */
        Integer len;            /* length for copy */
        Integer dist;      /* distance for copy */
        

        /* decode literals and length/distance pairs */
        do {
            symbol = decode(s, lencode);
            if (symbol < 0)
                return symbol;              /* invalid symbol */
            if (symbol < 256) {             /* literal: symbol is the byte */
                /* write out the literal */
                s.out += fbc_HexUtil.intToHexLE(symbol, 1);
                s.outcnt++;
            }
            else if (symbol > 256) {        /* length */
                /* get and compute length */
                symbol -= 257;
                //if (symbol >= 29)
                //    return -10;             /* invalid fixed code */
                len = lens[symbol] + bits(s, lext[symbol]);

                /* get and check distance */
                symbol = decode(s, distcode);
                //if (symbol < 0)
                //    return symbol;          /* invalid symbol */
                dist = dists[symbol] + bits(s, dext[symbol]);
                /* copy length bytes from distance bytes back */
                //if (s.out != null) {
                    //if (s.outcnt + len > s.outlen)
                    //    return 101;
                    while (len-- != 0) {
                        //s.out[s.outcnt] = //////
                        s.out +=
                            dist > s.outcnt ?
                                '00' :
                                s.out.mid((s.outcnt - dist)*2, 2);
                        s.outcnt++;
                    }
                //}
                //else
                //    s.outcnt += len;
            }
        } while (symbol != 256);            /* end of block symbol */

        /* done with a valid fixed or dynamic block */
        return 0;
    }

    /*
     * Process a fixed codes block.
     *
     * Format notes:
     *
     * - This block type can be useful for compressing small amounts of data for
     *   which the size of the code descriptions in a dynamic block exceeds the
     *   benefit of custom codes for that block.  For fixed codes, no bits are
     *   spent on code descriptions.  Instead the code lengths for literal/length
     *   codes and distance codes are fixed.  The specific lengths for each symbol
     *   can be seen in the "for" loops below.
     *
     * - The literal/length code is complete, but has two symbols that are invalid
     *   and should result in an error if received.  This cannot be implemented
     *   simply as an incomplete code since those two symbols are in the "middle"
     *   of the code.  They are eight bits long and the longest literal/length\
     *   code is nine bits.  Therefore the code must be constructed with those
     *   symbols, and the invalid symbols must be detected after decoding.
     *
     * - The fixed distance codes also have two invalid symbols that should result
     *   in an error if received.  Since all of the distance codes are the same
     *   length, this can be implemented as an incomplete code.  Then the invalid
     *   codes are detected while decoding.
     */

    private Integer virgin = 1;
    private Integer[] lencnt = getIntArray(MAXBITS+1), lensym = getIntArray(FIXLCODES);
    private Integer[] distcnt = getIntArray(MAXBITS+1), distsym = getIntArray(MAXDCODES);
    private Huffman lencode = new Huffman(), distcode = new Huffman();

    private integer fixed(State s)
    {
        /* build fixed huffman tables if first call (may not be thread safe) */
        if (virgin == 1) {
            Integer symbol;
            Integer[] lengths = getIntArray(FIXLCODES);

            /* construct lencode and distcode */
            lencode.count = lencnt;
            lencode.symbol = lensym;
            distcode.count = distcnt;
            distcode.symbol = distsym;

            /* literal/length table */
            for (symbol = 0; symbol < 144; symbol++)
                lengths[symbol] = 8;
            for (; symbol < 256; symbol++)
                lengths[symbol] = 9;
            for (; symbol < 280; symbol++)
                lengths[symbol] = 7;
            for (; symbol < FIXLCODES; symbol++)
                lengths[symbol] = 8;
            construct(lencode, lengths, FIXLCODES);

            /* distance table */
            for (symbol = 0; symbol < MAXDCODES; symbol++)
                lengths[symbol] = 5;
            construct(distcode, lengths, MAXDCODES);

            /* do this just once */
            virgin = 0;
        }

        /* decode data until end-of-block code */
        return codes(s, lencode, distcode);
    }

    /*
     * Process a dynamic codes block.
     *
     * Format notes:
     *
     * - A dynamic block starts with a description of the literal/length and
     *   distance codes for that block.  New dynamic blocks allow the compressor to
     *   rapidly adapt to changing data with new codes optimized for that data.
     *
     * - The codes used by the deflate format are "canonical", which means that
     *   the actual bits of the codes are generated in an unambiguous way simply
     *   from the number of bits in each code.  Therefore the code descriptions
     *   are simply a list of code lengths for each symbol.
     *
     * - The code lengths are stored in order for the symbols, so lengths are
     *   provided for each of the literal/length symbols, and for each of the
     *   distance symbols.
     *
     * - If a symbol is not used in the block, this is represented by a zero as
     *   as the code length.  This does not mean a zero-length code, but rather
     *   that no code should be created for this symbol.  There is no way in the
     *   deflate format to represent a zero-length code.
     *
     * - The maximum number of bits in a code is 15, so the possible lengths for
     *   any code are 1..15.
     *
     * - The fact that a length of zero is not permitted for a code has an
     *   interesting consequence.  Normally if only one symbol is used for a given
     *   code, then in fact that code could be represented with zero bits.  However
     *   in deflate, that code has to be at least one bit.  So for example, if
     *   only a single distance base symbol appears in a block, then it will be
     *   represented by a single code of length one, in particular one 0 bit.  This
     *   is an incomplete code, since if a 1 bit is received, it has no meaning,
     *   and should result in an error.  So incomplete distance codes of one symbol
     *   should be permitted, and the receipt of invalid codes should be handled.
     *
     * - It is also possible to have a single literal/length code, but that code
     *   must be the end-of-block code, since every dynamic block has one.  This
     *   is not the most efficient way to create an empty block (an empty fixed
     *   block is fewer bits), but it is allowed by the format.  So incomplete
     *   literal/length codes of one symbol should also be permitted.
     *
     * - If there are only literal codes and no lengths, then there are no distance
     *   codes.  This is represented by one distance code with zero bits.
     *
     * - The list of up to 286 length/literal lengths and up to 30 distance lengths
     *   are themselves compressed using Huffman codes and run-length encoding.  In
     *   the list of code lengths, a 0 symbol means no code, a 1..15 symbol means
     *   that length, and the symbols 16, 17, and 18 are run-length instructions.
     *   Each of 16, 17, and 18 are follwed by extra bits to define the length of
     *   the run.  16 copies the last length 3 to 6 times.  17 represents 3 to 10
     *   zero lengths, and 18 represents 11 to 138 zero lengths.  Unused symbols
     *   are common, hence the special coding for zero lengths.
     *
     * - The symbols for 0..18 are Huffman coded, and so that code must be
     *   described first.  This is simply a sequence of up to 19 three-bit values
     *   representing no code (0) or the code length for that symbol (1..7).
     *
     * - A dynamic block starts with three fixed-size counts from which is computed
     *   the number of literal/length code lengths, the number of distance code
     *   lengths, and the number of code length code lengths (ok, you come up with
     *   a better name!) in the code descriptions.  For the literal/length and
     *   distance codes, lengths after those provided are considered zero, i.e. no
     *   code.  The code length code lengths are received in a permuted order (see
     *   the order[] array below) to make a short code length code length list more
     *   likely.  As it turns out, very short and very long codes are less likely
     *   to be seen in a dynamic code description, hence what may appear initially
     *   to be a peculiar ordering.
     *
     * - Given the number of literal/length code lengths (nlen) and distance code
     *   lengths (ndist), then they are treated as one long list of nlen + ndist
     *   code lengths.  Therefore run-length coding can and often does cross the
     *   boundary between the two sets of lengths.
     *
     * - So to summarize, the code description at the start of a dynamic block is
     *   three counts for the number of code lengths for the literal/length codes,
     *   the distance codes, and the code length codes.  This is followed by the
     *   code length code lengths, three bits each.  This is used to construct the
     *   code length code which is used to read the remainder of the lengths.  Then
     *   the literal/length code lengths and distance lengths are read as a single
     *   set of lengths using the code length codes.  Codes are constructed from
     *   the resulting two sets of lengths, and then finally you can start
     *   decoding actual compressed data in the block.
     *
     * - For reference, a "typical" size for the code description in a dynamic
     *   block is around 80 bytes.
     */
    private Integer dynamic(State s)
    {
        Integer nlen, ndist, ncode;             /* number of lengths in descriptor */
        Integer index;                          /* index of lengths[] */
        Integer err;                            /* construct() return value */
        Integer[] lengths = getIntArray(MAXCODES);       /* descriptor code lengths */
        Integer[] lencnt = getIntArray(MAXBITS+1);
        Integer[] lensym = getIntArray(MAXLCODES);       /* lencode memory */
        Integer[] distcnt = getIntArray(MAXBITS+1);
        Integer[] distsym = getIntArray(MAXDCODES);       /* distcode memory */
        Huffman lencode = new Huffman();
        Huffman distcode = new Huffman();   /* length and distance codes */
        // permutation of code length codes
        final Integer[] order =  new List<Integer>    
            {16, 17, 18, 0, 8, 7, 9, 6, 10, 5, 11, 4, 12, 3, 13, 2, 14, 1, 15};

        /* construct lencode and distcode */
        lencode.count = lencnt;
        lencode.symbol = lensym;
        distcode.count = distcnt;
        distcode.symbol = distsym;

        /* get number of lengths in each table, check lengths */
        nlen = bits(s, 5) + 257;
        ndist = bits(s, 5) + 1;
        ncode = bits(s, 4) + 4;
        if (nlen > MAXLCODES || ndist > MAXDCODES)
            return -3;                      /* bad counts */

        /* read code length code lengths (really), missing lengths are zero */
        for (index = 0; index < ncode; index++)
            lengths[order[index]] = bits(s, 3);
        for (; index < 19; index++)
            lengths[order[index]] = 0;

        /* build huffman table for code lengths codes (use lencode temporarily) */
        err = construct(lencode, lengths, 19);
        if (err != 0)               /* require complete code set here */
            return -4;

        /* read length/literal and distance code length tables */
        index = 0;
        while (index < nlen + ndist) {
            Integer symbol;             /* decoded value */
            Integer len;                /* last length to repeat */

            symbol = decode(s, lencode);
            if (symbol < 0)
                return symbol;          /* invalid symbol */
            if (symbol < 16)                /* length in 0..15 */
                lengths[index++] = symbol;
            else {                          /* repeat instruction */
                len = 0;                    /* assume repeating zeros */
                if (symbol == 16) {         /* repeat last length 3..6 times */
                    if (index == 0)
                        return -5;          /* no last length! */
                    len = lengths[index - 1];       /* last length */
                    symbol = 3 + bits(s, 2);
                }
                else if (symbol == 17)      /* repeat zero 3..10 times */
                    symbol = 3 + bits(s, 3);
                else                        /* == 18, repeat zero 11..138 times */
                    symbol = 11 + bits(s, 7);
                if (index + symbol > nlen + ndist)
                    return -6;              /* too many lengths! */
                while (symbol-- != 0)            /* repeat last or zero symbol times */
                    lengths[index++] = len;
            }
        }

        /* check for end-of-block code -- there better be one! */
        if (lengths[256] == 0)
            return -9;

        /* build huffman table for literal/length codes */
        err = construct(lencode, lengths, nlen);
        if (err!=0 && (err < 0 || nlen != lencode.count[0] + lencode.count[1]))
            return -7;      /* incomplete code ok only for single length 1 code */

        /* build huffman table for distance codes */
        err = construct(distcode, removeNElems(lengths, nlen), ndist);
        if (err!=0 && (err < 0 || ndist != distcode.count[0] + distcode.count[1]))
            return -8;      /* incomplete code ok only for single length 1 code */

        /* decode data until end-of-block code */
        return codes(s, lencode, distcode);
    }

    /*
     * Inflate source to dest.  On return, destlen and sourcelen are updated to the
     * size of the uncompressed data and the size of the deflate data respectively.
     * On success, the return value of puff() is zero.  If there is an error in the
     * source data, i.e. it is not in the deflate format, then a negative value is
     * returned.  If there is not enough input available or there is not enough
     * output space, then a positive error is returned.  In that case, destlen and
     * sourcelen are not updated to facilitate retrying from the beginning with the
     * provision of more input data or more output space.  In the case of invalid
     * inflate data (a negative error), the dest and source pointers are updated to
     * facilitate the debugging of deflators.
     *
     * puff() also has a mode to determine the size of the uncompressed output with
     * no output written.  For this dest must be (unsigned char *)0.  In this case,
     * the input value of *destlen is ignored, and on return *destlen is set to the
     * size of the uncompressed output.
     *
     * The return codes are:
     *
     *   2:  available inflate data did not terminate
     *   1:  output space exhausted before completing inflate
     *   0:  successful inflate
     *  -1:  invalid block type (type == 3)
     *  -2:  stored block length did not match one's complement
     *  -3:  dynamic block code description: too many length or distance codes
     *  -4:  dynamic block code description: code lengths codes incomplete
     *  -5:  dynamic block code description: repeat lengths with no first length
     *  -6:  dynamic block code description: repeat more than specified lengths
     *  -7:  dynamic block code description: invalid literal/length code lengths
     *  -8:  dynamic block code description: invalid distance code lengths
     *  -9:  dynamic block code description: missing end-of-block code
     * -10:  invalid literal/length or distance code in fixed or dynamic block
     * -11:  distance is too far back in fixed or dynamic block
     *
     * Format notes:
     *
     * - Three bits are read for each block to determine the kind of block and
     *   whether or not it is the last block.  Then the block is decoded and the
     *   process repeated if it was not the last block.
     *
     * - The leftover bits in the last byte of the deflate data after the last
     *   block (if it was a fixed or dynamic block) are undefined and have no
     *   expected values to check.
     */
    //int puff(unsigned char *dest,           /* pointer to destination pointer */
             //unsigned long *destlen,        /* amount of output space */
             //const unsigned char *source,   /* pointer to source data pointer */
             //unsigned long *sourcelen)      /* amount of input available */
    private State s = new State();             /* input/output state */
    public fbc_Puff(String source, Integer srclen, Integer destlen){
        /* initialize output state */
        s.out = '';
        s.outlen = destlen;                /* ignored if dest is NIL */
        s.outcnt = 0;

        /* initialize input state */
        s.inStr = source;
        s.inlen = srclen;
        s.incnt = 0;
        s.bitbuf = 0;
        s.bitcnt = 0;
    }

    public String inflate()
    {
        Integer blockNum = 0;
        Integer last, type;             /* block information */
        Integer err;                    /* return value */

        /* process blocks until last block or error */
        do {
            last = bits(s, 1);         /* one if last block */
            type = bits(s, 2);         /* block type 0..3 */
            err = type == 0 ?
                    stored(s) :
                    (type == 1 ?
                        fixed(s) :
                        (type == 2 ?
                            dynamic(s) :
                            -1));       /* type == 3, invalid */
            if (err != 0)
                break;                  /* return with error */
        } while (last == 0);
        
        System.assertEquals(0, err);
        return s.out;
    }
}