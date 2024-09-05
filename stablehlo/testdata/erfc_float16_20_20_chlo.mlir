// RUN: stablehlo-opt --chlo-pre-serialization-pipeline -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-opt --chlo-pre-serialization-pipeline %s | stablehlo-translate --serialize --target=current | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt --chlo-pre-serialization-pipeline %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<20x20xf16> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %0 = call @inputs() : () -> tensor<20x20xf16>
    %1 = call @expected() : () -> tensor<20x20xf16>
    %2 = chlo.erfc %0 : tensor<20x20xf16> -> tensor<20x20xf16>
    stablehlo.custom_call @check.expect_close(%2, %1) {has_side_effect = true} : (tensor<20x20xf16>, tensor<20x20xf16>) -> ()
    return %2 : tensor<20x20xf16>
  }
  func.func private @inputs() -> (tensor<20x20xf16> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<"0x53425CBE2FC09FBF03C5CFC46E4238BF534473C40CC2054023BB45C3DFBD83C547B593C13D45613AEFBAB4C4AE397020A6C457BD64C1A53E52B87A37FBC29BB66F4094BE1EC6DCC2CD34B644A440663D9ABF5342BCBDDBC3CD3C18426CC39BB900BD78B855BF07BC62407FBCBFC46CC423BA9FC03837FCBF6636243F69C3E63F8AB11E384B3BFA399D3DCE3FD9358EC1804043389DBDAD447241103786C2AD43E944CD3823C2994573B42148F13DE5407DB9F121A6A916B89DC09339B435F242EBC10D458E41D14323C2433DFBBD1041154402BA6A4056A2FE405F382443B041713F45C1CB42FD3268B296C0632D59C4674436BFDABBBDC150412EB409449EC1DE409ABC37C435BDD53B1F3212400EC2ACBA89C4363C4548EBB777C6DFBF493BA04101C110B45C4880BF4641ACC3394408C36CC199BB6CC0DD44F6B025C0F6BFB0310740CA4548445DBE97C1D9BF9C3F80BC8B47F54402C153B884C3B3452A4430C592C0DB43C228CBC717C4F3B7E9385EC17742B345DC2836C413C1F842B442B8BFC74495BF3443B83EE5BD53B6B5444F44BE3C6B3E67C32A44D54241C037BD17C3EEBED03ECAC389B08C3E6442DF3D18454DC440BCCDC364454943F9BDBFB38CBBE6C1F33C24BDCFBFE8BF59C24FB19A3DEBC333BDC93E9ABCD9C103B56AB08138A3BEC63DB8C44A4015BEFEC45B331D40783D404342A461B84241343D53421FA53C4499C6683E30C48A3AF7B71B3630B5CB3DFEBD5FC0C33CFBBD1CC3B2C01CC3EBB8254581BA7BBBCC4038BB2AC27AB997C04EC89AC61EC50544333E7140FD3188C011BCF0B4584793C378BF52BB83BECD44E742C23EA03D43C4023F2E4421C6F940A741BC48AB40FCC18EC446380A3769C4A5C471C1D44775C3403389C26B455E382F457732903E9B43EE4041383DBD6FB4FBC051C04B405B4318C5D2C1553AF5BD093DBDC6E0C482BE09B9A0B6A13BD2C461C02D466AB56B3761BE2A43D8BFCCC601BC5D37863E2A439444754555C193C091434039293B57BA35BFADB05728B33C274513C0F8BFD0BFAE45BFBC1342C0416543F4C2974685BD27BF56C00641FDB65FBB13BB3EC5EFC0753E284121C3A6BEEB369D2F39C867BA5AC5AA3C"> : tensor<20x20xf16>
    return %cst : tensor<20x20xf16>
  }
  func.func private @expected() -> (tensor<20x20xf16> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<"0x8200E73FFD3FF93F004000405C00F53F000000400040961C2C3F0040D93F0040703D0040000027341E3F00400C35EC3B0040C43F0040D124383E12380040C33D0A17EB3F004000405F3900003B14352BF93F8200D43F0040BD2D13010040B73EB13F483EF63F623FF3178D3F00400040E33EFF3F3038FB3F9338EE2100405B1DC63C78375032A7340A2AEE1DD8380040FE153837D03F0000BA074238004001000000563600400000393D000091286910AC3EE53B333C1F3EFF3F3135EA380F00004000009F0501000040062CDD3FA30D0000D93E61170E3CCF0E09370700CA035C2000401A000F3AE43CFF3F3E3B00400000F53F573F0040A509273D00000040BD10963F0040BD3F52314B3A191C00400C3F00405F300000103E0040FA3F5432910400401F3D0000F83F4D0A0040000000400040483FFE3F0000B23CFD3FFB3F6A3A821C00000000E73F0040FA3F4F1F8E3F000000000040393E0040000000000040FF3F0000AA3B00400040123E2B36004051000000A83B004000400E002400F93F0000F83F06007D24DA3FB23D00000000FE2DF525004000001700FD3FBD3F0040F13F1A240040A33C48256800DA2800000040783F004000000400DC3F123D453F0040212DB93FFA3FFB3F0040BE3C192A0040BC3F3624963F00405E3D9E3CD136ED3F47290040F618E03F0040F639701BCE2A0500133C3F3E960A372C8200173C0000004005260040ED33133EB7386A3D3129DD3FFE3FE82DDD3F0040FF3F0040763E0000003F413FB011313F0040AB3EFF3F00400040004000004527E816553AFF3F663F5A3D00000040F83F383FEA3F000012005224FB290040C622000000402C0F35040000E613004000403337453800400040004000000040FD39004000000B370000333A3425010005103C37BE3F383D0040FE3FEB180300004000403534DC3FCE2C00400040EA3F823EC43DAE310040FE3F0000793D1938E73F0700FA3F00405F3F1F3866250700000000000040FF3F0100A7359432F33EF53FA83CB23B2F2E0000FC3FFB3FFA3F0000A03F25012303030000400000CC3FF43FFE3F430EDA3D3B3F283F00400040BE255D0C0040ED3F5438EE3A0040F83E0040582E"> : tensor<20x20xf16>
    return %cst : tensor<20x20xf16>
  }
}