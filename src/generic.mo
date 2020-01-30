/**
 * Module      : generic.mo
 * Copyright   : 2019 Enzo Haussecker
 * License     : Apache 2.0
 * Maintainer  : Enzo Haussecker <enzo@dfinity.org>
 * Stability   : Experimental
 */

import Common "../src/common.mo";
import List "mo:stdlib/list.mo";
import Prelude "mo:stdlib/prelude.mo";

type ErrorCorrection = Common.Common.ErrorCorrection;
type List<T> = List.List<T>;
type Matrix = Common.Common.Matrix;
type Version = Common.Common.Version;

module Generic {

  public func genericEncode(
    version : Version,
    level : ErrorCorrection,
    data : List<Bool>
  ) : ?Matrix {

/*

206 551 9241

encode' :: Version -> ErrorLevel -> BitStream -> Matrix
encode' ver ecl encodedInput = final'
    where
        bitstream = interleave ver ecl encodedInput
        modules = toModules bitstream
        (matrix,maskRef) = runReader (mask modules) ver

        format = F.encode ecl maskRef
        ver' = V.encode ver

        final = qrmApplyFormatInfo ver matrix format
        final' = qrmApplyVersionInfo ver final ver'

interleave :: Version -> ErrorLevel -> BitStream -> BitStream
interleave ver@(Version v) ecl rawCoded = result'
    where
        blocks :: [[BitStream]]
        blocks = chunks (chunksOf 8 $ mkDataCodewords ver ecl rawCoded) (qrDCWSizes v ecl)

        codewordPairs = map (genCodewords ver ecl . concat) blocks

        dataCodewords :: [[BitStream]]
        dataCodewords = map fst codewordPairs

        ecCodewords :: [[BitStream]]
        ecCodewords = map snd codewordPairs

        padRemainderBits i' = i' ++ take (qrRemainderBits info) "0000000"

        info = qrGetInfo ver
        result = concat $ concat (transpose dataCodewords) ++ concat (transpose ecCodewords)
        result' = padRemainderBits result

pad :: MonadPlus m => [[m a]] -> [[m a]]
pad xs = map go xs
    where
        go l = take len $ l ++ repeat mzero
        len = maximum . map length $ xs

transpose :: [[a]] -> [[a]]
transpose xs = foldl1 (zipWith mplus) xs'
    where xs' = pad $ map (map (:[])) xs

chunks :: [a] -> [Int] -> [[a]]
chunks = go []
    where
        go acc xs (n:ns) = go (take n xs : acc) (drop n xs) ns
        go acc _ [] = reverse acc

toCodewords :: BitStream -> Codewords
toCodewords = chunksOf 8

genCodewords :: Version -> ErrorLevel -> BitStream -> (Codewords, Codewords)
genCodewords ver@(Version v) ecl input = (toCodewords dataCodewords, toCodewords errorCodewords)
    where
        dataCodewords = input

        numErrorWords = qrNumErrorCodewordsPerBlock v ecl
        genPoly = mkPolynomial $ qrGenPoly numErrorWords

        poly = toECPoly ver ecl dataCodewords
        errorCodewords = gfpShowBin $ snd $ gfpQuotRem poly genPoly

mkDataCodewords :: Version -> ErrorLevel -> BitStream -> BitStream
mkDataCodewords (Version v) errLevel = fillPadCodewords . padBits . terminate
    where
        numDataBits = qrNumDataBits v errLevel
        terminate i' = i' ++ take (numDataBits - length i') "0000"
        padBits i' = i' ++ take padLength "0000000"
            where padLength = 8 - (length i' `rem` 8)
        fillPadCodewords i' = take numDataBits (i' ++ cycle "1110110000010001")

toECPoly :: Version -> ErrorLevel -> BitStream -> GFPolynomial
toECPoly (Version v) errLevel bitstream = gfpRightPad numErrorWords $ mkPolynomial $ map readBin $ chunksOf 8 bitstream
    where numErrorWords = qrNumErrorCodewordsPerBlock v errLevel

toModules :: BitStream -> Modules
toModules = map conv
    where conv '1' = Dark
          conv '0' = Light
          conv x = error $ "Invalid BitStream element " ++ show x




*/


    Prelude.printLn("Error: Generic encoder is not yet implemented!");
    Prelude.unreachable()
  };

}
