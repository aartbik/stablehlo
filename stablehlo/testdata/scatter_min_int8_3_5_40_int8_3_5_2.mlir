// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<3x5x40xi8> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<1> : tensor<2x1xi64>
    %0:2 = call @inputs() : () -> (tensor<3x5x40xi8>, tensor<3x5x2xi8>)
    %1 = call @expected() : () -> tensor<3x5x40xi8>
    %2 = "stablehlo.scatter"(%0#0, %c, %0#1) <{scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 1], inserted_window_dims = [2], scatter_dims_to_operand_dims = [2], index_vector_dim = 1>}> ({
    ^bb0(%arg0: tensor<i8>, %arg1: tensor<i8>):
      %3 = stablehlo.minimum %arg0, %arg1 : tensor<i8>
      stablehlo.return %3 : tensor<i8>
    }) : (tensor<3x5x40xi8>, tensor<2x1xi64>, tensor<3x5x2xi8>) -> tensor<3x5x40xi8>
    stablehlo.custom_call @check.expect_eq(%2, %1) {has_side_effect = true} : (tensor<3x5x40xi8>, tensor<3x5x40xi8>) -> ()
    return %2 : tensor<3x5x40xi8>
  }
  func.func private @inputs() -> (tensor<3x5x40xi8> {mhlo.layout_mode = "default"}, tensor<3x5x2xi8> {mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<"0x00FBFE0300FF04FA00020000000400FE0100000300FFFF01FCFE08030002FE00000103FDFF06FEFC01FC00000001FF00FF02FFFE0403000001FF020100000000FF000000FF000202FC0402FD000200020102FFFE040103FF010305FF0301FFFF02FFFE0203FEFF0100FF000101010100FFFF02FDFE0201FF000002040203FCFEFD00FF0200FE020403020404FD00FC0000FFFB01010000FAFE0203060200FF010400030300010003030000FFFD0001FF0002FE0104FEFE02FD00FE00FE0200FF06000000FFFD0300FEFF01FF00FE02000100010300FF0003FAFE04FDFDFFFF0002000100000002010800FE0300FE00FB01FEFC03FA00FF02FD020101FCFA0307FE0002FDFB00FD01FCFF00FD01FE02FF030201FDFFFEFCFFFCFFFA00FD00000000FE03000001FDFFFD0100FFFD0300FC01FF04FDFD0000020000FDFFFFFA01010004020000010001000300FFFDFFFFFA020800FD000203FCFF000200FFFEFF05000100FDFE040105000104FF00FE010301FEFB0005000004FE030104FFFFFFFF00FFFDFF00FA03010106010403FF010101030203FF00FE0100FBFDFCFEFD00FFFF0201020600000002030002FFFF05FD01030005FD0200FDFCFFFF01000000000103FF00FF00FC0203FD010502FC0004010300FB0500FB0301FF04010400FD0100030303000000FF000100FEFB07FF00000001FD03FF0202010000FD0603FE000003FEFD05FE00FF0400FD02FCFD00FD01FA00FB04FC020502FF0002000200FA070301FEFFFE000104FDFF02000100FCFB06FE01020002FD00FF030101FF0204FF06FDFE000000FF00FDFFFF05FC01FF020001020005FE02"> : tensor<3x5x40xi8>
    %c_0 = stablehlo.constant dense<[[[0, 1], [0, -1], [1, 3], [0, -1], [-3, 0]], [[0, -3], [-3, -4], [1, -1], [-1, -3], [0, -4]], [[0, 1], [3, 0], [1, 0], [-2, -1], [-3, -4]]]> : tensor<3x5x2xi8>
    return %c, %c_0 : tensor<3x5x40xi8>, tensor<3x5x2xi8>
  }
  func.func private @expected() -> (tensor<3x5x40xi8> {mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<"0x00FBFE0300FF04FA00020000000400FE0100000300FFFF01FCFE08030002FE00000103FDFF06FEFC01FC00000001FF00FF02FFFE0403000001FF020100000000FF000000FF000202FC0402FD000200020101FFFE040103FF010305FF0301FFFF02FFFE0203FEFF0100FF000101010100FFFF02FDFE0201FF00FF02040203FCFEFD00FF0200FE020403020404FD00FC0000FFFB01010000FAFE0203060200FF0104FD030300010003030000FFFD0001FF0002FE0104FEFE02FD00FE00FE0200FF06000000FFFD0300FEFD01FF00FE02000100010300FF0003FAFE04FDFDFFFF0002000100000002010800FE0300FE00FB01FCFC03FA00FF02FD020101FCFA0307FE0002FDFB00FD01FCFF00FD01FE02FF030201FDFFFEFCFFFCFFFA00FD00000000FE03000001FDFFFD0100FFFD0300FC01FF04FDFD0000020000FDFFFFFA010100FD020000010001000300FFFDFFFFFA020800FD000203FCFF000200FFFEFF05000100FDFE04010500FC04FF00FE010301FEFB0005000004FE030104FFFFFFFF00FFFDFF00FA03010106010403FF010101000203FF00FE0100FBFDFCFEFD00FFFF0201020600000002030002FFFF05FD01030005FD0200FDFCFFFF01000000000103FF00FF00FC0203FD010502FC0004010300FB0500FB0301FF04010400FD0100000303000000FF000100FEFB07FF00000001FD03FF0202010000FD0603FE000003FEFD05FE00FF04FEFD02FCFD00FD01FA00FB04FC020502FF0002000200FA070301FEFFFE000104FDFF02000100FCFBFCFE01020002FD00FF030101FF0204FF06FDFE000000FF00FDFFFF05FC01FF020001020005FE02"> : tensor<3x5x40xi8>
    return %c : tensor<3x5x40xi8>
  }
}
