// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<3x5x40xui8> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<1> : tensor<2x1xi64>
    %0:2 = call @inputs() : () -> (tensor<3x5x40xui8>, tensor<3x5x2xui8>)
    %1 = call @expected() : () -> tensor<3x5x40xui8>
    %2 = "stablehlo.scatter"(%0#0, %c, %0#1) <{scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 1], inserted_window_dims = [2], scatter_dims_to_operand_dims = [2], index_vector_dim = 1>}> ({
    ^bb0(%arg0: tensor<ui8>, %arg1: tensor<ui8>):
      %3 = stablehlo.add %arg0, %arg1 : tensor<ui8>
      stablehlo.return %3 : tensor<ui8>
    }) : (tensor<3x5x40xui8>, tensor<2x1xi64>, tensor<3x5x2xui8>) -> tensor<3x5x40xui8>
    stablehlo.custom_call @check.expect_eq(%2, %1) {has_side_effect = true} : (tensor<3x5x40xui8>, tensor<3x5x40xui8>) -> ()
    return %2 : tensor<3x5x40xui8>
  }
  func.func private @inputs() -> (tensor<3x5x40xui8> {mhlo.layout_mode = "default"}, tensor<3x5x2xui8> {mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<"0x050004030000060108040304040801010204000100010001040104040000060201020001030000040103050403040101000000030300000304000003030602010502010202020400020100060401000306040003010000000003070100010202050100000202000100030203030200050102010201000204010106010302010303020101000502060006000402000000000100050401000002000101020000030000030000010002020205000100010500020003010300000403000207020200010003010401010301030100000401000102010100000001010200010007030002060105000201010204030001010202030202000000010002050503000303000102040003030301010002010405030000000200040300020203030700000100040501030306050500000403010100050200010200000002010102030303010302030400020006000103030205030001030100020100000000050300000403000101040100030301000200000600080302030100020003020101000201000301020202050403000000000200000205000300020000040502020002010000020404060600020000020000030303000000040702020202000100070101020102020003030103070103020300020005000101030100010101020400020205060106020401010201000000010203020102020100040303040101010100020302020000010002050101020201000100000401000203020002020101020608010001020303020200010101030103000001000102010400020003010301080006020403010004010604000301000200050202040101000200030103"> : tensor<3x5x40xui8>
    %c_0 = stablehlo.constant dense<[[[4, 2], [0, 0], [2, 0], [0, 3], [8, 3]], [[1, 3], [4, 0], [3, 0], [3, 3], [3, 2]], [[4, 3], [1, 0], [4, 1], [2, 1], [4, 0]]]> : tensor<3x5x2xui8>
    return %c, %c_0 : tensor<3x5x40xui8>, tensor<3x5x2xui8>
  }
  func.func private @expected() -> (tensor<3x5x40xui8> {mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<"0x05060403000006010804030404080101020400010001000104010404000006020102000103000004010305040304010100000003030000030400000303060201050201020202040002010006040100030606000301000000000307010001020205010000020200010003020303020005010201020100020401040601030201030302010100050206000600040200000000010005040100000200010102000003000B030000010002020205000100010500020003010300000403000207020200010003010401010301070100000401000102010100000001010200010007030002060105000201010204030001010202030602000000010002050503000303000102040003030301010002010405030000000200040300020206030700000100040501030306050500000403010100050200010200000002010102030303010302090400020006000103030205030001030100020100000000050300000403000101040100030301000700000600080302030100020003020101000201000301020202050403000000000200000205000307020000040502020002010000020404060600020000020000030303000000040702020202000100080101020102020003030103070103020300020005000101030100010101020400020205060106020901010201000000010203020102020100040303040101010100020302020000010002050101020204000100000401000203020002020101020608010001020303020200010101030103000001000102050400020003010301080006020403010004010604000301000200050202040101000200030103"> : tensor<3x5x40xui8>
    return %c : tensor<3x5x40xui8>
  }
}