// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

library GluttonsMouth {

    //Mouth
   function _GluttonsMouthArr() external pure returns(string[39] memory mouth) {
        mouth = [
            "https://b6erqt2pwngv4cmwrwp4ao3an2sfgkjfe6d3y4qmaa6xorgpsoia.ardrive.net/D4kYT0-zTV4Jlo2fwDtgbqRTKSUnh7xyDAA9d0TPk5A?",
            "https://z6ralh5zbqp5th5zq47kfwtqa26oe5mrljyc3ksg6rubyodsb3oq.ardrive.net/z6IFn7kMH9mfuYc-otpwBrzidZFacC2qRvRoHDhyDt0?",
            "https://axahmigrapfq2rqhqsoyg6xjoxve2prtun3dnz2gqf764qdsn5ya.ardrive.net/BcB2INEDyw1GB4Sdg3rpdepNPjOjdjbnRoF_7kByb3A?",
            "https://cbsy5oksyxtgng4ovryhmqefqm7scyryzt4hr6zyhgbuq66fcfcq.ardrive.net/EGWOuVLF5mabjqxwdkCFgz8hYjjM-Hj7ODmDSHvFEUU?",
            "https://nywyflp72rq7c6zfedkpz7sbdioyvcr5y6ucelv5wj7npv25ipfq.ardrive.net/bi2Crf_UYfF7JSDU_P5BGh2Kij3HqCIuvbJ-19ddQ8s?",
            "https://6v6m4r7o33s7mhzw5pnpnjtmrghp7j5wk6dzvk5invixdexqrtsq.ardrive.net/9XzOR-7e5fYfNuva9qZsiY7_p7ZXh5qrqG1RcZLwjOU?",
            "https://cbev3mhba2raaoh47osod5ie3n3onupaclb36o2qw32hopfm62aq.ardrive.net/EEldsOEGogA4_Puk4fUE23bm0eASw787ULb0dzys9oE?",
            "https://k7duf5viazpnsctcf45zbjcmyl2j4si4otvs2unzbncgsecuolrq.ardrive.net/V8dC9qgGXtkKYi87kKRMwvSeSRx06y1RuQtEaRBUcuM?",
            "https://eximwvczevvqfkbncpophcbdzdzht2sjuigvygolu3g6zxto53nq.ardrive.net/JdDLVFklawKoLRPc84gjyPJ56kmiDVwZy6bN7N5u7ts?",
            "https://znd6kugyiih55zyjvjdkldp7i2e3fffc7hdtv4rwnndnccwnxkaa.ardrive.net/y0flUNhCD97nCapGpY3_RomylKL5xzryNmtG0QrNuoA?",
            "https://mapfm3qhlqsgltnkl6xy7grdw7rxa5x3ifu6zvtkdxkjqzc4uepa.ardrive.net/YB5WbgdcJGXNql-vj5ojt-NwdvtBaezWah3UmGRcoR4?",
            "https://gcpe6wxp6na7fdm75cmtq574zstc6bylxsik425dpdxf7xwgio5a.ardrive.net/MJ5PWu_zQfKNn-iZOHf8zKYvBwu8kK5ro3juX97GQ7o?",
            "https://o3dclca3tff2gps7xgjszdoomjfod7airxm2k7xxxccpmd6kurbq.ardrive.net/dsYliBuZS6M-X7mTLI3OYkrh_AiN2aV-97iE9g_KpEM?",
            "https://dxyxuazyu5qqtsubfizosv2x3nzhmvlo5m4kqtrzceonl2ah6rlq.ardrive.net/HfF6AzinYQnKgSoy6VdX23J2VW7rOKhOOREc1egH9Fc?",
            "https://44w4xxsb7x5wsnr3btlhqpdlq4puqykpggmouithrbchauj6mzzq.ardrive.net/5y3L3kH9-2k2OwzWeDxrhx9IYU8xmOoiZ4hEcFE-ZnM?",
            "https://sefael27ztxs5caj3c7smjomzutapx5nzut3jd3hisona3h3m2ga.ardrive.net/kQoCL1_M7y6ICdi_JiXMzSYH363NJ7SPZ0Sc0Gz7Zow?",
            "https://kjmekcoea2mwvlrojodkq6olo7gxz3ndbkmabcpyn644oh4l5t2a.ardrive.net/UlhFCcQGmWquLkuGqHnLd8187aMKmACJ-G-5xx-L7PQ?",
            "https://nk3rlf2bx6ikbs54x7fvuczimgyewqzu7tqd5mwad23q3nr6hpnq.ardrive.net/arcVl0G_kKDLvL_LWgsoYbBLQzT84D6ywB63DbY-O9s?",
            "https://qbxtbll4mxylwq3jjsbpajz235p3c56fklukntkygs645klivtlq.ardrive.net/gG8wrXxl8LtDaUyC8Cc631-xd8VS6KbNWDS9zqlorNc?",
            "https://sjxc32ynbpix2vc4ehqcd4d7pumy6el67dhzhrniiemvxcjbp5lq.ardrive.net/km4t6w0L0X1UXCHgIfB_fRmPEX74z5PFqEEZW4khf1c?",
            "https://cfzsrqccoqtg7plendqy2jmiokbewqwrqmxtah7vihvyxvh2zota.ardrive.net/EXMowEJ0Jm-9ZGjhjSWIcoJLQtGDLzAf9UHri9T6y6Y?",
            "https://oekez2tcj56dnuubycueuv23hcjuac5jfpi2oly2wq4lzfkq56yq.ardrive.net/cRRM6mJPfDbSgcCoSldbOJNAC6kr0acvGrQ4vJVQ77E?",
            "https://zxnabxifmmysqzkwr6ryk6fuptaen6njzdllwqpcdpc6re3wtrpq.ardrive.net/zdoA3QVjMShlVo-jhXi0fMBG-anI1rtB4hvF6JN2nF8?",
            "https://plwuyca5scn3bifag6uknk3uvdwjz4rojq4qiajrl5onxc43xwea.ardrive.net/eu1MCB2Qm7CgoDeopqt0qOyc8i5MOQQBMV9c24ubvYg?",
            "https://hzeiqlqf52btc43ms4rubk7xyprbg6ej33r2zvsqdboisrdcrj4a.ardrive.net/PkiILgXugzFzbJcjQKv3w-ITeIne46zWUBhciURiing?",
            "https://n5in6re55oklcz5k64qgjm2lazkfx3zh6et4sx5zxvli6v4gidda.ardrive.net/b1DfRJ3rlLFnqvcgZLNLBlRb7yfxJ8lfub1Wj1eGQMY?",
            "https://bkdklh6sc77wov5kxjeqofthlwcus2whyfir4ju3br4qo4wuwvfa.ardrive.net/Coaln9IX_2dXqrpJBxZnXYVJasfBUR4mmwx5B3LUtUo?",
            "https://5kyv2fxn4qvdaqksc3gwx3zevmckpy3fjl7mv2dlzbap4orijbfa.ardrive.net/6rFdFu3kKjBBUhbNa-8kqwSn42VK_sroa8hA_jooSEo?",
            "https://xzkk52tfcs5h2dvzapke2jgtotweogwxjgh3xlvypfrj5g6bsc3q.ardrive.net/vlSu6mUUun0OuQPUTSTTdOxHGtdJj7uuuHlinpvBkLc?",
            "https://gyyr4gbicx5jgyztqugtqd5v3xnn4sfy7garhxid725qibtlhe3a.ardrive.net/NjEeGCgV-pNjM4UNOA-13dreSLj5gRPdA_67BAZrOTY?",
            "https://7b5q2t2oyt2xku7cgnkwrxesuqz5ol522jl6nvudguvpiyz4wwta.ardrive.net/-HsNT07E9XVT4jNVaNySpDPXL7rSV-bWgzUq9GM8taY?",
            "https://a2fkutl6x4auxowudsrqhu3fvmhfvxaoe5ldwkqh6tk2ardjp4hq.ardrive.net/BoqqTX6_AUu61ByjA9Nlqw5a3A4nVjsqB_TVoERpfw8?",
            "https://vowj7xhg3x2r4zumj6ea6qa2nvitsjodqj4lbdn3d5nfzwxlwnyq.ardrive.net/q6yf3Obd9R5mjE-ID0AabVE5JcOCeLCNux9aXNrrs3E?",
            "https://3zoqdetcn73v35bgsrl3mqmjthexljpmmxv3pz4uphteuejpu5nq.ardrive.net/3l0BkmJv9130JpRXtkGJmcl1pexl67fnlHnmShEvp1s?",
            "https://drencnhoiz2pdccduemd3d72hhcshneypkkj5ab4jms3zpzf5tfq.ardrive.net/HEjRNO5GdPGIQ6EYPY_6OcUjtJh6lJ6APEslvL8l7Ms?",
            "https://jzyezsfrzgog24iwxeml2egp3rn56klg3ftjnflutmgkxswko5tq.ardrive.net/TnBMyLHJnG1xFrkYvRDP3FvfKWbZZpaVdJsMq8rKd2c?",
            "https://afkqybqx3lam2zhg3ieb3vfha42bvi2bk6uamuwrjif3tv4n54aa.ardrive.net/AVUMBhfawM1k5toIHdSnBzQao0FXqAZS0UoLudeN7wA?",
            "https://zddgv5pjiket76rp53o2ixizqnqqdmtc5szfczk6goiplsx4m2va.ardrive.net/yMZq9elCiT_6L-7dpF0Zg2EBsmLsslFlXjOQ9cr8Zqo?",
            "https://qkxqkhuuaoosyppevih4nksdljxhacj4rfzxxr7asqwynz3mwgwq.ardrive.net/gq8FHpQDnSw95KoPxqpDWm5wCTyJc3vH4JQthudssa0?"
        ];
    }

    function _GluttonsMouthArr1() external pure returns(string[39] memory mouth) {
        mouth = [
            "Banana",
            "Burp",
            "Chomper",
            "Clench",
            "Cluster",
            "Crave",
            "Double",
            "Down",
            "Drool",
            "Fangs",
            "FourTeeth",
            "Full",
            "Fun",
            "Gap",
            "Glad",
            "Grin",
            "Gums",
            "Happy",
            "Hotdog",
            "Joy",
            "Lick",
            "Open",
            "Out",
            "Pizza",
            "Potato",
            "Pout",
            "Sad",
            "Scared",
            "Silly",
            "Snarl",
            "Snouter",
            "Spaguetti",
            "Stitch",
            "Thirsty",
            "ThreeTeeth",
            "Tooth",
            "Trace",
            "Wavy",
            "Yumi"
        ];
    }

}