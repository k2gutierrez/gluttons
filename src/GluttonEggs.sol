// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

library GluttonEggs {

  function _getUnhatchedEggs() external pure returns(string[4] memory unhatched) {
    unhatched = [
      "zi3467xyt434qimesq7tt7dqdtjzhs6ndrym3ytcdsfyiz5tmmqq.ardrive.net/yjfPfvifN8ghhJQ_OfxwHNOTy80ccM3iYhyLhGezYyE?",
      "gjwr5ovfqqkmoku3th33t35cqebqimjtto4oui3mmmw7z4ocfabq.ardrive.net/Mm0euqWEFMcqm5n3ue-igQMEMTObuOojbGMt_PHCKAM?",
      "wvuggnt7zf2vnvo5ffxhytywdjx5hhujfkwa2d5gwoxddsgwle3q.ardrive.net/tWhjNn_JdVbV3SlufE8WGm_TnokqrA0PprOuMcjWWTc?",
      "2k3hodhigrdtwgaca7jucs4aktns4nqmduuykcehlci7hladuhea.ardrive.net/0rZ3DOg0RzsYAgfTQUuAVNsuNgwdKYUIh1iR86wDocg?"
    ];
  }

  function _getHatchedEggs() external pure returns(string[4] memory hatched) {
    hatched = [
      "rcai6si2twxcklrxxovtmyfuesohggkqcco6x5wm6y3p5sadohwq.ardrive.net/iICPSRqdriUuN7urNmC0JJxzGVAQnev2zPY2_sgDce0?",
      "ah5af5cenhonq3gfk3rydl3pikqhz75z5e4qj6bvz4pzdbhoxgqq.ardrive.net/AfoC9ERp3NhsxVbjga9vQqB8_7npOQT4Nc8fkYTuuaE?",
      "f23e5qrfiut43ricw5iol6j3ts57o77jb7q47ar36o2ozpl75jfq.ardrive.net/LrZOwiVFJ83FArdQ5fk7nLv3f-kP4c-CO_O07L1_6ks?",
      "w2xmb4birfezlqzthmmvfx5cs2gkysgjybpc7vknqwwhd25bwwca.ardrive.net/tq7A8CiJSZXDMzsZUt-iloysSMnAXi_VTYWsceuhtYQ?"
    ];
  }

}