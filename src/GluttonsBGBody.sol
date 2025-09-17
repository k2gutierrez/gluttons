// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

library GluttonsBGBody {

    //BG
    function _GluttonsBackground() external pure returns(string memory bg){
        bg = 'https://x2fbshsrjfr652nzjgiwpbrwy7ic7js2pdwqxmembkhuz4c5vvlq.ardrive.net/vooZHlFJY-7puUmRZ4Y2x9Avplp47QuwjAqPTPBdrVc?';
    }

   function _GluttonsBodyArr() external pure returns(string[4] memory body){
        body = [
            "https://idhluwebfvncf6qk34okfq3wtmgzhhmx2mv4zxuvaiozimrntdsq.ardrive.net/QM66WIEtWiL6Ct8cosN2mw2TnZfTK8zelQIdlDItmOU?",
            "https://hucj6jnpav7k2zylzxwod6k7axjgtqer3welu65nljugldnn6l5q.ardrive.net/PQSfJa8Ffq1nC83s4flfBdJpwJHdiLp7rVpoZY2t8vs?",
            "https://bq6mh2x42rhv32baf3ifs3dvqs5obo5t3kudlcpyrmf5q2kgsnwa.ardrive.net/DDzD6vzUT13oIC7QWWx1hLrgu7PaqDWJ-IsL2GlGk2w?",
            "https://73vs22ltt7pugtufvddxgd4u2jpg3wcbzr2xqr4j3u2skcl52r2q.ardrive.net/_ustaXOf30NOhajHcw-U0l5t2EHMdXhHid01JQl91HU?"
        ];
    }

    function _GluttonsBodyArr1() external pure returns(string[4] memory body){
        body = ["Bubblegum Bile", "Grape Guts", "Mango Muck", "Puke Green"];
    }

}