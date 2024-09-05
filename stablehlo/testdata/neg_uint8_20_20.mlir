// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<20x20xui8> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %0 = call @inputs() : () -> tensor<20x20xui8>
    %1 = call @expected() : () -> tensor<20x20xui8>
    %2 = stablehlo.negate %0 : tensor<20x20xui8>
    stablehlo.custom_call @check.expect_eq(%2, %1) {has_side_effect = true} : (tensor<20x20xui8>, tensor<20x20xui8>) -> ()
    return %2 : tensor<20x20xui8>
  }
  func.func private @inputs() -> (tensor<20x20xui8> {mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<"0x00060202040400040304030002030301030002000101050104000100000301020004020203020000020000040202000202030101030100010001020004030307020000000102000102020004020005020100010003010401040102040505010702000302030203000200020403010300020200040002010300030301000104020500020103000002030001000201070107000303000204040301030107020102040003000202030402000100010300010000070301020102030302030102050102000000070304030501050101050303020502010703000002020300020007030300020202010103000301020001020104020102050100000003010301010106000705020103000004000000020005060700040202030003020102000700000005000205000501030003030202000400000003040A00020300020000010004030001000002030302000102000203030103020101000301000203000204030001030105030000010300010602000006030203020001050100010302000301040402010202010101020407000001020500"> : tensor<20x20xui8>
    return %c : tensor<20x20xui8>
  }
  func.func private @expected() -> (tensor<20x20xui8> {mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<"0x00FAFEFEFCFC00FCFDFCFD00FEFDFDFFFD00FE00FFFFFBFFFC00FF0000FDFFFE00FCFEFEFDFE0000FE0000FCFEFE00FEFEFDFFFFFDFF00FF00FFFE00FCFDFDF9FE000000FFFE00FFFEFE00FCFE00FBFEFF00FF00FDFFFCFFFCFFFEFCFBFBFFF9FE00FDFEFDFEFD00FE00FEFCFDFFFD00FEFE00FC00FEFFFD00FDFDFF00FFFCFEFB00FEFFFD0000FEFD00FF00FEFFF9FFF900FDFD00FEFCFCFDFFFDFFF9FEFFFEFC00FD00FEFEFDFCFE00FF00FFFD00FF0000F9FDFFFEFFFEFDFDFEFDFFFEFBFFFE000000F9FDFCFDFBFFFBFFFFFBFDFDFEFBFEFFF9FD0000FEFEFD00FE00F9FDFD00FEFEFEFFFFFD00FDFFFE00FFFEFFFCFEFFFEFBFF000000FDFFFDFFFFFFFA00F9FBFEFFFD0000FC000000FE00FBFAF900FCFEFEFD00FDFEFFFE00F9000000FB00FEFB00FBFFFD00FDFDFEFE00FC000000FDFCF600FEFD00FE0000FF00FCFD00FF0000FEFDFDFE00FFFE00FEFDFDFFFDFEFFFF00FDFF00FEFD00FEFCFD00FFFDFFFBFD0000FFFD00FFFAFE0000FAFDFEFDFE00FFFBFF00FFFDFE00FDFFFCFCFEFFFEFEFFFFFFFEFCF90000FFFEFB00"> : tensor<20x20xui8>
    return %c : tensor<20x20xui8>
  }
}