// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<3x2xf64> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %0 = call @inputs() : () -> tensor<2x3xf64>
    %1 = call @expected() : () -> tensor<3x2xf64>
    %2 = stablehlo.reshape %0 : (tensor<2x3xf64>) -> tensor<3x2xf64>
    stablehlo.custom_call @check.expect_close(%2, %1) {has_side_effect = true} : (tensor<3x2xf64>, tensor<3x2xf64>) -> ()
    return %2 : tensor<3x2xf64>
  }
  func.func private @inputs() -> (tensor<2x3xf64> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<[[-2.4769515279267078, -3.9417650234036818, 3.7265509545172635], [-3.5866178507101436, -5.8366036882496086, -1.3450993943329561]]> : tensor<2x3xf64>
    return %cst : tensor<2x3xf64>
  }
  func.func private @expected() -> (tensor<3x2xf64> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<[[-2.4769515279267078, -3.9417650234036818], [3.7265509545172635, -3.5866178507101436], [-5.8366036882496086, -1.3450993943329561]]> : tensor<3x2xf64>
    return %cst : tensor<3x2xf64>
  }
}