// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<4x2x3x5xf32> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %c = stablehlo.constant dense<[0, 4]> : tensor<2xi64>
    %0:2 = call @inputs() : () -> (tensor<4x2x3x5xf32>, tensor<4x3xf32>)
    %1 = call @expected() : () -> tensor<4x2x3x5xf32>
    %2 = "stablehlo.scatter"(%0#0, %c, %0#1) <{scatter_dimension_numbers = #stablehlo.scatter<update_window_dims = [0, 1], inserted_window_dims = [1, 3], scatter_dims_to_operand_dims = [1, 3]>, unique_indices = true}> ({
    ^bb0(%arg0: tensor<f32>, %arg1: tensor<f32>):
      %3 = stablehlo.add %arg0, %arg1 : tensor<f32>
      stablehlo.return %3 : tensor<f32>
    }) : (tensor<4x2x3x5xf32>, tensor<2xi64>, tensor<4x3xf32>) -> tensor<4x2x3x5xf32>
    stablehlo.custom_call @check.expect_close(%2, %1) {has_side_effect = true} : (tensor<4x2x3x5xf32>, tensor<4x2x3x5xf32>) -> ()
    return %2 : tensor<4x2x3x5xf32>
  }
  func.func private @inputs() -> (tensor<4x2x3x5xf32> {mhlo.layout_mode = "default"}, tensor<4x3xf32> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<"0xD41E11C05075893F469D3DC001ABD6BECAF1B9C02F0988C02CC20A40BF9E8BC00C4C663FE6D39DC0063B8B4049E4B9C05918D83F78405E3F817D64BF4925893E66BB52C00727F43FCFEADE3FF8441140181C7B3F412E6E3FB63D13C0318259C0522C8AC08C70563FF21438C04B244C4065998DC03A75B44001CB92C07E4A6AC00FD7C93FD52670C0903011400650963FCD5B2FC0D4B918404C9E8840124893BF8F6C70C06CE56E402B2B513F793F3240457F9540CBDF9B3F0A9B0C404DEF1E41D22D71BFEE26C1400D1D97C01E311340D99926BF809A19C0FB49C53F7BC0474005D0734056BBFF3E0C2D4FC0DE30553D395570409BDB10408497EBBEC64C4BBFC8DCE03E83E895403C31FCBE6CC409C0DE6A334008F300C02BFDCE3F388C48406093A9C0DBAF27C0850A5840E2C42C3CCCE528BFF9804D40490ED1BEC56679409B28F8BF4B619D3E1C0B093FDBFBD03F57C771C0F8BE773E0629A1401DB8213FC65445BF7FD0CFBE91C3B6C0893F02C06A25BE3DE8F4BFBEB24E29BFB56F17BFAAC61CC08B35CEC08DE83840EA171BC085DA88BFE643B640DD665740B5E2213ED9F1683F4C5417BF5585113FABC4684019A1C5BE6335144061DB073F982444C06D01423F23D76A409701AEBF00513DC0BBFC99402221B040455532BE7D1F27BE"> : tensor<4x2x3x5xf32>
    %cst_0 = stablehlo.constant dense<[[-5.77315092, 3.44449806, -3.178960e+00], [1.04211497, 0.0453308262, -2.22651935], [-0.432207704, -2.53150225, 2.6740911], [-3.71027708, -1.02697015, -4.27390671]]> : tensor<4x3xf32>
    return %cst, %cst_0 : tensor<4x2x3x5xf32>, tensor<4x3xf32>
  }
  func.func private @expected() -> (tensor<4x2x3x5xf32> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<"0xD41E11C05075893F469D3DC001ABD6BEB85739C12F0988C02CC20A40BF9E8BC00C4C663F486ABEBF063B8B4049E4B9C05918D83F78405E3FBB4982C04925893E66BB52C00727F43FCFEADE3FF8441140181C7B3F412E6E3FB63D13C0318259C0522C8AC08C70563FF21438C04B244C4065998DC03A75B44001CB92C07E4A6AC00FD7C93FD52670C093E253400650963FCD5B2FC0D4B918404C9E8840AB7A8DBF8F6C70C06CE56E402B2B513F793F32403F7F1C40CBDF9B3F0A9B0C404DEF1E41D22D71BFEE26C1400D1D97C01E311340D99926BF809A19C0FB49C53F7BC0474005D0734056BBFF3E0C2D4FC0DE30553D395570409BDB10408497EBBEC64C4BBF009DE43B83E895403C31FCBE6CC409C0DE6A3340957B91C02BFDCE3F388C48406093A9C0DBAF27C06A97C140E2C42C3CCCE528BFF9804D40490ED1BEC56679409B28F8BF4B619D3E1C0B093FDBFBD03F57C771C0F8BE773E0629A1401DB8213FC65445BF7FD0CFBE91C3B6C0893F02C06A25BE3DE8F4BFBE6DE48BC0B56F17BFAAC61CC08B35CEC08DE83840CBD15CC085DA88BFE643B640DD665740B5E2213E3A4B57C04C5417BF5585113FABC4684019A1C5BE6335144061DB073F982444C06D01423F23D76A409701AEBF00513DC0BBFC99402221B040455532BE7D1F27BE"> : tensor<4x2x3x5xf32>
    return %cst : tensor<4x2x3x5xf32>
  }
}
