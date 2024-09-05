// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<3x3xbf16> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %0:2 = call @inputs() : () -> (tensor<3x3xbf16>, tensor<3x3xbf16>)
    %1 = call @expected() : () -> tensor<3x3xbf16>
    %2 = stablehlo.minimum %0#0, %0#1 : tensor<3x3xbf16>
    stablehlo.custom_call @check.expect_close(%2, %1) {has_side_effect = true} : (tensor<3x3xbf16>, tensor<3x3xbf16>) -> ()
    return %2 : tensor<3x3xbf16>
  }
  func.func private @inputs() -> (tensor<3x3xbf16> {mhlo.layout_mode = "default"}, tensor<3x3xbf16> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<[[0x7FC0, 0x7FC0, 0x7FC0], [0x7F80, 0x7F80, 0x7F80], [0xFF80, 0xFF80, 0xFF80]]> : tensor<3x3xbf16>
    %cst_0 = stablehlo.constant dense<[[0x7FC0, 0x7F80, 0xFF80], [0x7FC0, 0x7F80, 0xFF80], [0x7FC0, 0x7F80, 0xFF80]]> : tensor<3x3xbf16>
    return %cst, %cst_0 : tensor<3x3xbf16>, tensor<3x3xbf16>
  }
  func.func private @expected() -> (tensor<3x3xbf16> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<[[0x7FC0, 0x7FC0, 0x7FC0], [0x7FC0, 0x7F80, 0xFF80], [0x7FC0, 0xFF80, 0xFF80]]> : tensor<3x3xbf16>
    return %cst : tensor<3x3xbf16>
  }
}