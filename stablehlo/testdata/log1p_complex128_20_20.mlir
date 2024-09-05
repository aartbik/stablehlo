// RUN: stablehlo-opt -inline %s | stablehlo-translate --interpret
// RUN: stablehlo-translate --serialize --target=current %s | stablehlo-translate --deserialize | stablehlo-opt > %t.0
// RUN: stablehlo-opt %s > %t.1
// RUN: diff %t.0 %t.1

module @jit_main attributes {mhlo.num_partitions = 1 : i32, mhlo.num_replicas = 1 : i32} {
  func.func public @main() -> (tensor<20x20xcomplex<f64>> {jax.result_info = "", mhlo.layout_mode = "default"}) {
    %0 = call @inputs() : () -> tensor<20x20xcomplex<f64>>
    %1 = call @expected() : () -> tensor<20x20xcomplex<f64>>
    %2 = stablehlo.log_plus_one %0 : tensor<20x20xcomplex<f64>>
    stablehlo.custom_call @check.expect_almost_eq(%2, %1) {has_side_effect = true} : (tensor<20x20xcomplex<f64>>, tensor<20x20xcomplex<f64>>) -> ()
    return %2 : tensor<20x20xcomplex<f64>>
  }
  func.func private @inputs() -> (tensor<20x20xcomplex<f64>> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<"0x0E01DA21A37219C07A5B2840FF3807C0E2541549EB1C0040FEFA29105E510BC06036707499A7F53F6AF75D4694760B40045BB5465559D1BFBD8C6897FA6E0740F5FDC71AA2B9F03F09599869634306C0EA3945F068010CC04FDC25D67484F73FA7D1AC39B1B412409A3B8F5FD8CE07C086B1BFF7A8D803C0BEE3A5F77AF70A40FAEDC508DC5D08402044B3772DA3DA3FAF7942008E2CF7BF643B13CD33FB0D401902480E5401124029CDACDE9015F4BF54952AA5A9CCEF3F4FC09CB58359F2BF6CB25A8FE42FED3F10CD3DE25B9EDFBF141582E0A682F9BF5E549AC85A02F6BF69B131627BB4F6BF7CDFF12A4005DEBFC81C0CB7C0D2D13FB4913A9AFE2C134012CAD46B916409C00CD59878F1B7D33F514B0140739B11C048A9A96074C3C23F921B73FB6D290140B81C7677101D074068154C3C395F00C04270083069C80BC006DA0E6094F2E9BF526AB5F80CC810C068D8CB8DF876124026696E089724C53F3E9C50AE364DE83FE6B2CF34B5741D40E228CC75A168ECBFE48069EFD169F7BFDE8F192FBA7B0040B154C1232BB20540EB1DB30D52E3C8BF266D31E6B99A00402E6B5F81E3D016C077133A48ED14E33F81DF9BBA0246E8BF916A2ECB4B17E6BF02F0308E2D16E1BF07591C873EB102C0BE14E657C024ECBFE891BC158F0717403C547C21047D0940E2EC30FACE15F23F3EA4896945CC16C0D2200445041A0140036A1BC598C6B7BFD964855DEBD002C0C4C3F2435B36F93FFFC8E02BD0B0A03F4A5BBDE469BC1D40AD29ABFD6248F33F8A9EFB741C9E0C408077244D8E01723F57CF220B3AA302C044C874EA1E18F83F68FCBAD845A4C23F3DA798572B48FEBF3C11E1AD79051240A8AADE557D9709400A295F4341F0CD3F422D8CFC9F35DF3F7F924E10DB8E01402BF2E158C40E0DC0089B1F998CD707406CF728EA5BFFF7BFB9BE9B5D798A02403D5EAFFBEC91024045FBADFB7FB6F1BF42C713C0EFD9F13F4B807D7A36FE10400CA37FC918D7C23F24A0F70E0B0FF3BFF5F53B8AF354D43FB6A7F04B5D02FABF853169E1B6D8F5BF8EA5104C215EF1BF7EE4001BC3D0E83FFE011DF4D2B60BC0110D157E5944F4BF0CD52F09AB40EB3FD884F04D3E1D154040462FDFFF9BFABFD684C9A5F57501406CA7AADA369EABBFD959A91E50E8C63FE440AE0559FA01C03CED45BBA2E2E13FD4243004EA06E63F4B0F4D4E70E0FC3FE8739B8EB5EF0CC0ACF1FCB5BF5D0BC04E9ECA33E9D511C0722CB0E147B10A405861996D6705EA3F7D204674E5D00B401D9324EDF6EAFF3F711B2C99085BF1BF263DE3CE712518C0BD1954EDC46BE23FE65124C1AB4F01C05ACDE1152FDAFD3F861FA3435D0E0640FEF3A417A3C80D406E23A3965E8D0440C2866D712D6D104052128C2B6C14DFBF5AD62FB2E2E0DB3FD3FCFE3E6B7FF33FA81969B87720FEBFCA3A4B1036240340ACB313A6100AFD3F9F3D04C5932F0840D86214FC2B07DC3FE81F94E688AFDDBFC7F5A9B322A005409638F8357797E53F92B261841CBC0C40F6816741A1500DC064FF095086C9F73FD8A828D60AA4FD3F60457CA93CE617406DDB19F2F3ACDF3F300C107D8E89F9BF1E661248ED3FC63F040BBA2222200AC0F80B5BD32C62F93F4DA62553E580F43F1D49CF72010B10C054AD6AFCD8AF01C0830A35830393FD3F57EAAC0DA7AA04C032C0C475A113FE3F3011241FF2A409C04034C8B1367F0EC0201002A178240AC0F9E8BCD543A7F13F5F0BA8BD353F10402AED02A6874802C07E3D622B126CCD3F492A1E3DA4DDB43FC0E8AEC1A3DBBDBFF24C828AEADCF03F48963B3A3BEE21C099D6747B9E22C63F3C3576B839BB02C0BE0499DD4F6F02C0ACF4356209200940DA75B81494891B40AA55F08F9594FABFF23293B5E3E512409AD76FE30B8DC93F54FC2C8EC03CFD3F6769AD0F208811C04FF7A67A495DF83F5CF8C798CE0603C052B01324211A1F401655CBFDA387F1BF1E6C8DB599B7FEBF98F5C3C15817014086355200B8BB06C02DFAB937A081C93F91D660E1A1A4FB3F469242E86085F53F57778FDC25950F40E03AAA66CD0D12404AA23665FCB2F9BF2CFF0650332A01C0BAD38D714DCB02C0A2ACAD97CEB0F43F1C4F18FF2860BF3F2C449A6DA5CC064005897F8CBD41D4BFD8B36E10B21E0740658E7FEF5859EBBFCD903777242713C0C02BCA22907618C0A3487921847706407C370F54D100F3BFC2D13BF60F23F6BFDA8F084FFACED93F1E49F1964961F0BFAC09E3B56AFE0AC02E20C74126CE13C0EC819692F4D6F83FF0095228EA0F15401070A6E9FC7904400F45FA267C65FE3F3084002FDDAA08C0A26BB14B3E790240EBDA8173A138D93FAC8CC8AC38340DC00E66B6721000E53F9C29817D224F084092131FCDA60E0540C0A77EE9D7D0F0BF34961C2A24AAF2BF734551BAD204F33F5CB63E3FA6011140DACD9078497D10C0ED09499C8BD4EA3F6D7B86C7763DE83F85B7E6FE1BF2F43F1A70B6CDB391E33F3BC3A2139A3100C022C00ADF3ECD13C0036E7E51C55F1BC0BE6FF81B392A1140FCCD837EF40908406E0B0A73FB260E4050C05E0532471A403A14F787A1D31140864F6A40ABD213C08CA7C817C39CF7BF60776E04489506C058E1BC4F74B2E83FFF5A999EB7C21A404C441DFD8F85D93FE245307B689917C0CD1CCBBE36870F407909535374681840ECFB9E75E1F7EF3FB6AB8F955A33F93F75D39DC525FAD4BFBA78CDD71ACBF03F128EBDECA1020240BAE506BA610C09C07C775187876F064071E82A9A672700C040995CCEA296F8BF5489F629747ADBBFD65F9F3220A2ECBF5705BDBB23010B406933DCAEBF4016C060517427B40BCD3FF0639166E54C00C04E6A9FEE665E99BF00F91B8EB2F6D43FED9C9FA6B9C6F53FFE941A14BB1F0D406B00B4835F66D83F06DAE90C2A1CF23FAE92E929F30B0E40234A0C85FDCDF03F126EB84D94D2FCBFEE6F10E63E3406402AA1DB096C38034034FF4BC478060D408773D8E481630740BAE748E60632F4BFE18F0ACF1514B73F4D8E5F540F59F63FFDFE42C5157FF0BFEAA496CB8D5CF43FE70DF79052C100C0869828E86791E2BF0064D2359EA5124010D8CAD95F3101C0D9E1364B670611C0F03F60EC7B0504C0CC8556A365140140F8A42AEBC4ED0F40098DAC50942D00C05C889310E0641240AA0D84A855691B40CC5E12371473F43F0611C31B76FCF4BF2F02A526E1C7F53FD89E7B2D7264E3BF1D573A492DBD04407D2C730B34A40D4094ABBA68008F11404F307817AAB30340E69D730EDA9C08C02D37509B7DABF2BF3A6C4581F02E1D406EBB5B19BCE4E03F1CD2EDBD9FFBF83F52FD0508FA9BF0BF0E0F5B02171005C05B8A54812940E2BFA6C1B85489729B3FACD503318DF302C0E0D62E27B80B06405B37BB2D1F6A02C097DCF1A80D96AA3F2FDF8E18975DF1BF81E9A1335DDD0140842DF50AD72A0D4001931D29593EC53F1983B6A883E70DC0681DF5B4D2EDE7BF7C4667C66F55ED3F98ABED3B78F8F63F599369EDB55410C0A3BBFF2F795DECBF6A6614790A6B0BC0548206C1E09D1640B869F9A2C684F6BF8001C6976CBBD13F19528FBC5E61F43FD818C0E7ADEEA2BF786E5372E5F7FBBFF8C60F37577980BF20A4A704B173E5BFA42007213C3904C09E80C0997A330D4033543DAE08EEE43F2ECB544D53E50240CB5607859F6EF0BFA438E93E2CAD02C0DAF8E2C526E60D4070028CA7B34F0340AC161F3D74450CC088F4D9B26E44FDBF8FCA0173E17703407410021FEA7816C0F1EC6063890EE4BFB4F63BBAAAE50740737624CDDD72F2BF7EF88378CC35FCBFF4C036932E3C1440ECD5B8003A36E13FE05597619C95E23F78DDC66BDD75E13FB3475DA6CDFD06408EB50C4166FDF13F6952E5C2DF71FABFB1C8203010A9F43F4273C6BBA00CFE3FC615E27F929CF0BF877FB7ECE32F0540FD4ECBD26B1AF03F30EC4A729A14F5BF0405A5E019B5BF3F9AC48E62DDD11840C2149069E28308C090BC6E5CCD5300C0F218C18FA88A03C0F0B84E292D98DDBF7C6BF45DBF71EF3FD2241F7109B523405F1637615B2992BFA0A3F38AFCCEFFBF5685CD9BFF5DFBBF9508203215C505C0A37BD0BCF78FF03FF435D954D0B511C01E902B39BB350D40E8D45A918C73F93FFE3C57702558EE3FCAF6C805B2BF1240F826652B0444D6BF4A9AF49A8257F8BF09C4D40F54DE18C035E96EBECAA3FE3FC80D1C80396DD83F3976EC818F9803C04F0FCCCD39B113C09C5B723ED18F1040C6B499D5ABAAF1BFD2E5BDCEF2B7E93FA0FC29459D3616C04C8A0E7450C300C024913D1833BC14C09051306804B60DC0D2591B526277F63F357C8C007AA600C096EA94233874F83F6AB6C93D0902FCBFE3C29F6C396409C0A4A9FFE215332040BEE221FC40CAE0BF0807271896960A409ABFFBDB7588134078926DAA1BE10E4032780C05FBB9E73F9BB2530E8F1CFA3F3CC081BF9280A4BF54698A067B2801C0242F5D99BE74DCBF378DEAF9335908C0E5C17AA7F8B50740DF87BD1FC3D803C074EBF7705FFBED3FD36E9D78FDCFE73FAC49F3D8282B0AC0F6354760E7761540FA94A8758468FE3F99196864E5421C401611D6F12942FCBF3B5669F37916F23FF061A942E2802540EA832BE7BCF202C0FCBC9344734D15409E38227F0F9412C0D3AC606E6A8600408CDBDBFB7357F33F5841BAC557B107409D84755CAC3801405BEFA07F5479F1BFABD6789EBC5AF3BF8F4A9E8F41A1E83FEB896A573A4B13C040B94319DB2C10C0B8D9566D7DFB08400F9A436908CF13C052EB2837FC760E4006B34C33DC5609C001B70AE4E1CDE6BF9CCDAE7A7B2EE3BF84B8F6682B2510402C9AB31EDF1B10C0CBB7DFF2C9E5D3BF93BE68A3FB18E53F604F0E58EADFEF3F8644FB46181110C00E4D949608FF14C0D1B84BC3F558F6BF746898FBC317B7BFE8010FE7642AB8BF66AE06FF042C11408D3ABDE41742D4BF1C9F1876165EFE3FE5313C5A9725B5BF54C10392B5CB03405E8DD59E3F3DFDBFE723C3B44A95F6BF86B8EF56D3350D40EC68E5DA666C0B404EF0C64F468CEBBF8C3F72617BBAF23F71C3381412C81CC078E5A8BBB930CABF4CD77F6A59E0C63FC7FD22E795050040A215DB2E884917407655E713A4FD16409A5B9FE5E813FE3FF9558649E69C1440ED4A48C7938CF4BFF93731C0EF0404C0701EC84967581440CCA2EF343AD2DEBFC812B073D266E4BF9950061BE57AFCBFC88B52E1BEA2F83F5EAFD9DC05EE084008BEBF204BEDEDBFB474FC5AB5BEFFBFB8B129BC9F41F43FCD2EFD023940EBBF6221247ADB2D00C05A295D9744DFF93F385AC0F1FCBA18C0F0E8606B5B0FF9BFF0A233C2F57690BFDE6F6685126C00C09BFBF7DC5919F8BFDE6277DD41E7EC3F1DCAAEC3DB9B0FC0E27786BAB7A50040928EB24DB93DED3FD67427F05F01C6BF94A10D648146084001126305770DF73F1C19DA81CA7C0DC06F8F5BF69CDDE3BF3AE0F70820DE0AC063649EF7D873E7BF7E81BE360BD0EC3F3AFC14B45E95024092D4FF0EEB29F2BFE405695361E92140CED680C02335F23F36E19DF87886004036ABB33B4615F03F2D57886B773FE9BF224D2DA8205D014090386F4AECB10A40C6613CA0F6950FC02A8B9A17C86B05C07E8269DB9F64F2BF18A1BD317F6E0340EDF4825C9EB415C08509C5597974F7BF84552E38CC7D16C06A7FC83D1FDAE8BF11D7246BF115004068221EF2F535D13FFCE902DD9A840C40A04784D03FE7FFBFBA7C2F326FABFD3F7A1DFC01502111402E53531710E6A6BFB90114660689E13FB29B59A350F803400D75D95E14B10940426BD275C03B0B405CD92CFE68D00040FC02926EBD270FC03AC38A54C1DD11C028AC1FC122BFE9BF2B6541D7287D0D40A7C7CDA62F38FE3FACC867DA30E50CC023ACD78DC571014088701D2989D1FA3F9192A4EC79FE1540CB0E227FE6FED53F69089D2CC3111340744AC0C64B86F7BFCDAC3A379299D3BF937122AAEE72DEBFEE4707BBD04A03405DF59512256FCCBFA3A3064BB792F73F70A9AADABCBF1F402D8677B0556DBF3F01561F076B4101C05F1310EE11D309C021B5B2F497A5A2BFE840444D285E0C40EEC192A5C2C81140989BD5497A42E43FCDA8A384414205C099A21C411ED90DC0C6D3F36973CD0EC0F071C388409B13C05C1F50605F381440F6BFAC3BFEAB10C0F09E87DD051303C079C6DB42D2D204C0E6077F1C09DDFD3F519273529AA4104026189F41A833F13FCC120909CCE90C409A4B8364B6AD10401941F499E28606C0A413DC037E3D1DC0A4DFAD7A485CE6BFCD3B5F05FA670E4069AE7165C7561AC04ED6888BB767DA3F218716092E0AB2BFE91B2F0E6D7F134030E516B51C7701C0CA0DCBFE3C1EEF3F4C1AA1B61D540440F1E270EF98AC0CC064734EA0685FFF3FB392FBD5CA25F13F8A9DA937EBCE0CC02D604EEF476CE33FC6E0A6B7C6C1F7BF8FDEB555847BF0BF5EFAB7D51F75F13FA751F8E6D4670BC0A06D81A0E3B80340E5B8AC6F6FFA1D40AC4F6CD72496EC3F662C1C6D18D6E7BFA6FFDE38DF7DF1BFCA519B79D39E03404CF0215DFFD91DC06255CFE11CCD0B408642E79A02970A40AC2BA4C93A970BC06E0292284918F63F52EF79985569014072BBFA3183B803C078A0125ABF2FC23FE66D3E165A68C4BF9B7A1E8F9AA01F409736D5FB4CCBF03FD05D060F58A5D13F8275E1B3278918C04A5A777D53DFFA3F0ADD1D35F0A9F0BF0D7198D63DCEE13F7CF4FDC9D5CF06C074606BC9C552F9BF5815AC017D36E5BFE77A9AA8E912FC3FABF16FDE10381640EA900C3905EC09C00B8F2FEA4A8ED33F24F44E08511407C02F39FB4C9C34F83F95481BCDBFA308404AE0CDC3CF190D4069588055719E0140D29E148DB85002402E73FE8C9E8111C04ACC0BD692EE09C0FEC549D1630AB9BF86C1AAA6D8BFD9BF8A0265C5B1BE0C40C54A96E0B0D81740EABF62CFCEF4E03F686C5D6F755201C05BA95F4A82F91040448605844641F8BFD421D6DE8FC8FFBF73B2332E710EF13FC4B745B6BAD907C0C05437BE3AC106C0F4E3A6088DF7E03F3CBB6B33E9DFF2BF9335DF59575E0B4077EB3AF843FD17C0C0960B80BA9E0CC0D805CF9D93B6FEBFC85A5F9F1DA51EC02E37AAA5A2C305402432F817C0020440D96546C38F0E0640CA005B069A48CF3F27C47F562A01F0BF28EB39C4A4A7E93F282969F00DF1DEBF080730F50EC1DEBF6ADFD2635FE0EA3FE6EC7EB3C1CA0CC072951F2844C0F1BF66B500463A35F1BF02201A7FA3ED0640D7CECD3DB54115C0AA3790DDE7C907408666FEB6171AE2BF1CD3A3242F1606C0E5C9F9ED776F02C03C00D427106C04C0A124D2F19D600DC08C5DEB414AA202C0C4F8974B1F960DC04400C3235785EDBF3FBF253B4F8700406E5F39559C5C05406F1BE4D09D57044008ECFE3E58A30AC03997396591F8F33F0CC6AEF9529015C0423E772300E4F63F26FB6590FFA8F7BF5AB24ADD05A7FCBFFA317E73A8ABF63F7BA1BF5FAFDB02C0348782272702C73FAA59B73C68941840124D82F4627D1440323959505D5FB3BFAE5CA8E424F0D5BFE654E62FA35701C0DEC56CB978D40140BC6EFF91C641FBBF84D9C56BF029DDBF61DFA86687E3F13F21B39B41F2A9BE3F1C0AB508390612406A6ADA1057F4FCBF3E2F525A35A9F2BF7E58D2B4C7CE0CC0F0776DA9774B11C00C768C52C3BB11C081843EA7D721E4BF4C355EDD84040F4078E619D259F4D53FA0A997269A27E43FE7FADCD52D5016C0ED1C8948E277DBBF128E85A7E3730740CCDAF932E039E13F26B8CA984DBB05408B1ADCD261D9F1BFC7584DF2CFC7064071E54D37C45906C09B4062A2CD12D6BFDE61BBA797D9C6BF64CF94A0845305C053F7A02E0BDF15C033C34BDA8D77F03F5B9BC636AE2718C02E5452002C15ED3F5AB69F73C447114006E6D88EDE04F33F6CCA06983CE2FA3F68CAA0ADFEB114C02218331AE4FAFBBF10FA6F2CEC91C9BF3A442464CC031AC04C4DC02B0EF006C074508760AB281240CFE83B8170C401C0B355E75B6789E73FD1CA03B9573DEBBF7BD7A5B61A7190BF7FEA5B023C9807C0073F139E7C2C00C0C10C6329A07F13401020D20480F4C03F18BCFD9CB6390F402A36AD6F23FFFA3FF2D2182F90BCF4BFECE4E74D9D4512C01BA3B747B41701C0088E4CF366F0F6BFAE563AA5E970EDBF05A15CEC3A6FE5BF9D06E7D5EB80024041057A577F34E0BF23E183591438EA3FBBFA40B81021E63FDF84E10E4006D63F9C098087E25912405A8EE440D833FA3F84B0F74F611E0C4048F299FB21EB02408AE5D824587ECFBFE67359C59B60D8BFB655106BD3DA08C04D1439FC8DDA13C0EC50813FA0910FC0E6742B2522A9E53F8656C9DABBB81E402003126CCC68FD3F39F993CE713409C069107F480A66D33F24971E680BDA0BC081F183F2DC78F33FAF07B38AC5ED0140FDA057ABFF35F7BF0E5E67080CAB0B40A164C71FC7D21340B802D4CCE1790140682FBC8A3A6C08C0A0C1CBE5CCA018C06E60ACD2D172EBBFD0D4E5AF83C015404DBF0347D66FF33F425C198663EBEC3F022083004C53E53FD4431D7F769DED3F17E7095F0400F43F1C0F50DFEF27F03FD9EADBDC8D7E1240442306EF40E6FBBFD2C6FA26029C11C03AA162E9C7D90CC0B68C5FBCD417F93FEF82A911440CE1BF128D2765BE4AFDBF0FD3DEA401B51140C83F4E39042EFDBF586B61B18E37FEBF6E72D126BF1E074070F2A9D27E4A04C05E1B94C972BD07C0B6518C233EFAF63F665526498D270AC03214AFF1E1F302C04759BB6EFC4207403F4BBBF2E4CA0240B6C16F6F297103407BC67C1B8F07D7BF46E2A42DF0440140A91A9C0A2D5413C0CD658AA9634B0540EC4D7ABCEB1005C0C2092BC5AC1FF13FE89AD31B78D1F03F66ABBF86193914405B89B328CC6307409419864B5E6D02409E7913850F03F13FD29E891611240940BBA58544D6DF18C0D172C590FE01D13F920E5313425DD73FC6A78D31DBC60E406C173BE59E2AF93FAB8411923A90F4BF"> : tensor<20x20xcomplex<f64>>
    return %cst : tensor<20x20xcomplex<f64>>
  }
  func.func private @expected() -> (tensor<20x20xcomplex<f64>> {mhlo.layout_mode = "default"}) {
    %cst = stablehlo.constant dense<"0x22279E27EEECFC3FD5689FB9C42905C014D8ADFA3042F83FC478B732CD1FEBBF4F80E83603D1F63F24F8D6CDE408EF3FE4BB4E8520ADF13F9DF595E1FD3AF53F23B2D5DBBED4F33F68A6DFE9D4FBEDBFD047661AFF09F13FC9D524C1B6E104404F12202353B9FD3FFF6C93126CE7DEBF2285EE64AEDAF43F498D363B61C1FF3FBE4E8F187C72F63F3B351B7D4C3EBA3FBB3E53C87540F53F74F6E3A9B709FB3FDEEE6B188FAFFB3F55E5CBDB06B7CCBF9E8BA1E961A7EA3F70EE846F47B4E0BF365434F3C1C6E53F41694694A32ED0BF9ED85EF5CAE2D93F0F99A463A4A8FFBF3B2D8AAA04ACDDBF880B1DED4A6602C04EB92EC996A0F93F08961A9C78F6F43FA52258657E2BE93F83D9DFA7AB010840328DFE478F9AF33F480FBDCFC8C9084068571288983AF73F602BA6759BC6E73FE8ABD1BB6D9DF43F5FB4146ECED0FDBF7AE48220BDF5F63FB8B5AFAE7269F8BF4C8F0FC60A9EFB3F49E61703C51B9E3FC8F402FBE1310040DD79B72B5C61F53F25DFA93EBA8DD83F4D9436E675E8F7BF691310A48988F63F38726F8C1E34E73FEFD4E414BF9CE93FE3A065FF8B35F33F4EE0A36BF1E6F83F34D93E3FBE1F08409D1B69CDEC05D4BFD21D4490D7BFF3BFC748A9A420C8EB3FCA46998D95FBF5BF812DB1EFDF02FC3F0D98AAB241CCF83FEDEB38639A78F73F1CB9D031FEE0D03F86CD9DC58743FA3FE9677216AEB70540E96C447A6396ED3FF1720BB43C3EF3BFB0EEB2B68147EE3F564ABE250AEB893F958498CD96230140F3517E80E22AC23FFCFD46E86056F83F2BCAE04A8B784F3F72621F41C352E63F75B771E1655A0240545B3342E768E93F9EB39625716CF0BF7FEF9AE2669EFD3F86B800091DD8E03F5F0674E96D18D23F4BAD17EF7416D83FAADF2A51C038F93F598051B1302EEBBFFD83C97BE929F73F41734D7E3F10D7BF20D91B1B2E60F63FA99B2D1A4889E33F184ABDA2BF33BD3FDC083470CEA9FA3F6DA30CBB5988FA3F26C0D591FFB59C3F2A8A7993DFBFEFBFCBF5B9236EE60040ECB170E1D207DA3F8B103C43DA0000C0A69360F8FDC5CFBF07E96950AAE3FA3FCEF23521534EF03F1BD8418E965505C0009EFD9AFD8BFB3FBE9C762B18BCF33F37D486269863EA3F2B06B04513DAFD3F84F33B55D863A3BF39CFA58D49EEC73FAD611D9DE5FED33F8B62468E2DC30540D6F6E345FAF3EC3FB9C5371AFA32EA3F85C7CD31315DF73F4853F34D75CA01C0244767EA131EF93FD75711EA59FE024008B8C91EEFDCF53F0AB376522071F13FDE63B1C85889F23FE62961C8653DD6BF55FCE456AFF8F93F4889EBA2EA3808404E01FB137337E93F256F1634430701405594817B92A6FA3F991918D3B1FCE83F3E65A4CB511AFB3FFD6A3B31CD5EEB3F63A60576DD3ED9BF177059CE347CE63F2317E8E30A17F13F1C21DF090485E6BF574360FB328FF53FC4EAD0653A70DF3F0D1756F01A5EF63F7DBD6A8EC3C1BB3F66FA27D43838F03F7AD2DE78F9FFF53F958908874C08F63F1EB9DE17EC26F23F6A47F42115D9F13F5410B213A20F054099BBC5885C3EFE3F9480CAB98301F23FCC86F765EB09E93F1A64F120F72DEABFFA0324A058E8F33F4D64ED309C9CF3BF34BCDDABF7F5F03FC12E1BB8AB70DD3F12D52CE2D415F53F79F39F3FCB1004C067BA0FDFC88CF53FE5605C508892E7BF7620D34C2F5FF73FB0D13FA314D8EABF181901C32761F73FC5506A49464002C0BF6EA71A8753F83F7B871F25D57CF13F3B8233049413D13F4CD7D8A795B707403E7833E3FE89B53FD6C0FE885F80BBBFB02FF9E162C001400AF9098C8387F5BF0549575882CEEE3F33073ABFC5B3F1BF8A2200F17695F33FAA4CC648526EFF3F7B5841575BB100401E61C572DA94CABF396FACD401EDFB3F191EA6D4B5D8A13F5CA871A7486DFA3F26AE7AD5B5EEEFBF0860A683A3E4F33F8519044A9B30E8BF936F482506700140848355C6FDCBBFBF499260E34703EB3F1F52C58E41A3FF3F160D547142BAE33FC45FA5F93E45084075544673EBCBF13FCB9793FCE451DD3F489479D8516DFE3F2E81BF562BAAE73FA56B847F83A8E93F6DED8A01D489FDBFAC331719E302E43FD0952948F6040340FA08BA4F18E9F13FA1772CE00A21F33F4DAE18115A6AF13FFF488C8FBF6AF53FF435246AE010F93FC6679C48B0A5F8BFCC9AABF67B39FC3F641EE3BECB1D0540E72E5971A15CD53F83A379624A4AFBBFB55C5C5955ABE13FCEF41F834E2BE4BF88CB45620940FB3F0E5909F4B32400C02FF9EBE57444FC3F130A02C726E9F13F720E8668BF51F63F7D29DA1F4560DF3F068817B49F27F23FB250F2FB50700240F76452E291CEF53F1B5CE94FC74BF3BF12EA1C0314DDF33F9824D7CAE225F13F5735C373CC47F53F22C1111AC706D2BF90809D54275EC73F10640AE1225CFB3F723DF1078760FE3FC1747BB9D74BE5BFBB1E12F090FEE53F5C3913137C03D93FED21B8C43ADDEB3F0EA4B32AB391D03FE6E989F54AEDF93FCD3BF1FFA165FCBFBEFEB57224B2FF3F64A499EBBF10044018F95A1F4746FB3FA0859E408C29E83F4195B57D2D6201403AB150FC1A07E13FD491530A8E0BF73F7688ED02AF4606C0F2F749D607DAE53FC3F2592DC1ED0540F59B9B6A8C540040CA0647D5B986AA3F7098B79C206BFD3FCC666A46BAB6034068B6F94ED585FF3F4A41E8FF49E3C13F2F60C2935986EE3FB3F4344F9E34C0BFE80B7F4C40D0F13F8C3E6E16E2A1EA3FE8E33F024A25F43F07BDE066C4C30140A1E5C7E33995E33F527A4A08584001C0CA724DCF4F72AE3FE9B5EE1BA00CF0BFCF90F24AB64FFF3F3CF011094CF0ECBF332EB9A9E1B9EB3F6FE69D3BF075F0BF13ACC11E5E0A9D3FCF2CC2530FBDD43F043131EB8A7BF73F1C24DF89B1DAEF3F9CBE362D268EE23F7821AE19C2F7E53F868CB99CB654F93FD120D4C93FD2CB3F94C31C5D57F9F03F119198105CA1FD3FC2DD31B1EBAAF93F08663B48C428EA3FDD10BBFCF0A8F63FBEC375B868EBD3BFEFDB2D18D94DE23F19B39385D90EED3F61FDF12CC2E4CE3F91E5BE25D385F93F3EBBD9A08C66CB3FC2D3E3CD8C3B05C03E7B610008D1FC3F764890B7DA37D7BF3D159DDC489AF63FE7370DC4F5E303C017850F7756FDF93FB76E2B7C7DF5EC3FDE7A39E92FCCF83FF5BA667AF5A1FC3F0A98FF8373970040FE5E052FCFA6C43F188BDCD9E95FD53F3676F7F0C6BBFC3F2BBDED0603D9EE3F6904890A33B8F63FA09AC642A9C9FD3FF6D3ACE0E305E83F6CC3AF132A87F83F32A5818CD03EE7BF473DEEB511CDFF3F64260BCEA57FF93FF6646C369D01E93F6248580AD67AE93F44F2A5DF47FBEE3FE1535852385DF9BF72D3B4F539F8EABF951E77A920E6AF3F4CF3E69DB9FBF13FD7E3B626384100404E5594907CEED03FE6D3B4F055D008402771F7D04FBBE93F83B0A0AA74BEF93F3DF38FCE0596F83FD9AFD3EB4448A23FD2D73184FFB0F03F1E76DAE8F8FF06C0C46D6469DEF1EB3FA98F38038192E43FEC4A43AC06A6F23F813B491391E406C0E2F63E414A12FD3FD9C1E30BE59EFF3FE6C8017DC2A6E6BFA4B141C7E35A0440088E9A12524AEA3FDBD23D0DBEA690BF79D44A78B693D2BF32958C8DF50B09C06C623CC260F2ED3FFEA0DC0DE30EF7BFBD9723B23FBFF83FD36FD38CE3E2C13FD8C7F8333B1DF43F728E8B986FF9D2BF0FBDF86AE20DF63FFF5EDAFFCA9EFE3F57E77E24DA78F93F197514B873AFE9BF27F928A27037EE3FDD7BAD161F63FE3FA03D172B2DA0F83F39F3BA22B60D08C02312AB7790C5F63F57FE44D14404D2BFF6FACFC2341EFA3F03ED29214187FB3FC0906E82C7CFDF3FAF66A374011CD73FDA8D14995EECF23F494880F2DA3CF13F033CB5C02CAFEF3FA7C6492B8228E5BF5585735D9060F13F51C1DE87C7F8E53FBAD1B4D3722BEF3F406CBBFA185DF93FECE450BE1105EC3FBBDF6A7DD497E2BFE864922FBA76FD3FA8CB18310F44F63F9E31E017360DF13F74FBD0C832E502C09ECE00902796DA3F78FCF956BFA606C0FCA6348520760240CD3629EBAFF4F53F646FB25DCB7BE93F03EB30714CCAF1BF138383FD7B8BF03F6DC0F04E0038FDBF48CEA33BC856F93FC58683E0333DF2BF2933C3A5A17AF93FC00B2EA1FB16D53FBD3B0F8408FEF93F943842E172D4F23F7D1599994520E03F67C7BFF259A7F2BF9906DE233A71FB3FD4B5DCE483510640FB3ECC56458BF03FD219235E60EAF0BF5A30B043B5DBFB3FB82327474AA2024072C6771BA2E7CABFE22C5557EB31FB3F5113AFF057CAF93FD5E4BE28B3AE05C0A99971B6548CFB3F7AA28308335303C0FE29F7667082F23F8DD80C5957D5E6BF651E9F0C56F9F13F735B8E8ACE60E3BFB5A631554F03014024C9ADC30354FD3FCFE66729DF60F33F40F1BD6324DCF63FC487259EB937FF3F294FBE799B94E23F1A16755C11D6EB3F89963EBC3618E83FD7ABD205A856EB3F446F65143866F2BFD21B390A0A12F23F150BB522B23EF6BFA0D5A12E02AEF83F54D4592425E5E1BFF8951E9FAF5BE73FA89EA61C9E79D73FF22FFB142733FC3FE5BA769FE189FF3F299AF16ABC4300400F413D2F63E6F23F4EFDB7D8B8F1D33F074A8CBECF5401403A10F4B40BDF034007D6FFC1FB74C9BF5DFE80AE527B004069AEAE815A44E4BF5EBA22558C14F33FF97A5129E209D83F3B750CB99818F83FC101FC0026DBDF3F3E025B7B95BBC83F65E0543C5059FABF5B8A0AB8A92FFA3F9C8D0FA6A781F3BF0C24173A0090F73F588E9BCF40BF0240691A4352EB3DFB3F539BA6A481FF024097724E684065EA3F102663356A9706C02372C7115667F63F6A4385C0CE8CF73FB1C4F11A66CEF13F3D09103B625008C042937689F220E53FF5B797CBF14CE13FBC6A0B41DDCFFC3F03EEBE8443BD00C0EA006C5B40C7ECBF64BCD127175807C0F84E44C8F7A8F73F59E7B4036BCEF53FAED6F37BBC74E63F1E239CE9359AF33F4B80FEDAAE0DEF3F493C5491C273F33FFE9816F33882DF3FBE6EE0F7EDCE00C03D5CE4519C10FC3FAA756C66E752E43F5A07BBA6510DC53F9B1DD1A0693DF73F9704ECC08830FD3F24495A345EDE08C08D3914FBB7FBEA3F8D124EB70E9FF03F16B54853B7810140403FF1F8A367E63F6FE936FA8368FC3FBF20BDAA9EFAF03F10CED4A0AF8EED3F269AB57260F1FABF19DA423458F2FC3FBADB7CF5C136B4BFD55B6C23091AE33FC46B6F7231EBF5BFD41B23F9C642F63F1B70F4281662EC3FC27DA7BB12F1E53FF7CF4563499CF8BF34CBABAC614AEC3FD356DDC1B401D7BFA8236F1669C2E43F2F247BBAAD1301408ADF94E32C06FB3F1AE6BD5DECC806C0DC4B38ADAC52EA3FA3FA736D39FBF1BF0ABDE9F298CFA13FFCB4E8B820A70040FEDBEA9E2F8BF43FCDBFB5992D380440DAAD21DA34E6E43F31377CA065EFB6BF9A15AE4C3247F73FA174D299D1F3D53FBAD2156D8C39F03FF5853C5ACB5007C068B5EF9E63EEEC3FBC1971ABF0B806C0922D16EFA095F13F9AD204AFDC52EC3F97BF3846128A0140C5CAE0BED35FF93F8B7E3E70B06EF13F4A95B8921295E83F32D0018F1E91E83FD3AF0731E0FDD7BF008360AB4D6DF83F4CDF20676BF3E93F485F3E0A7C1CF63F874B6FAFEA3B03C01D11E2F19375EC3F37B08392E11DFA3FE33BA62E48A2F83F6F0DC57C019306C03F1951BA05B8F83F7EA16B391BCD07C0ECB23101CBB2F13FD3EC800137CEB63FF5F6AA37DDB0F93F797A3DD4875BDABF9938A69F9E36FA3F438CF9FEED73EF3F883CE20CD1B2B83FC67D732270AAE03F9C076008DEEBF83FD874E1FD63C6E73F7FAA632CBC5CF93F8D6348671D7FDC3FBAC073862FC0FA3FB78ED6A68C2A01C02E98EBEA46E5F43F5DC1136E0949F83F33D6E73AEC80F83F91BE78449BADECBF6115887A3B79F43F9C95F77F7B0ADF3F35FB0523AFF7FD3FDC1E504E790DAB3FDAFF6FE8038AFC3F8F1DDFBB6BF3CFBF2C3DF411D321C6BF8FEF4EA1643CE3BF9708E5FC1DABF33FC6B455855CA5B0BF5AD8C84E76F1004061812693B04CF43F39E4DF79376FEC3FE4036A2B2674F1BF81CF7A96F7A3E93FA03FA024820009C0B54E80FFE398FD3F74F99C89F4C6E83FC0C89EE85633F23F71D5F3D3D650F0BFC8F76ED9AAD4F83FD8D4DFA97A8001C06CA19DB22EAAFD3F2A239A5630D3014022E5CCE8350AF63FF426479BA7F803C0D29769BD23CFEC3F6830CCC0393E024016A4C8E2DF98FA3FAD93708A214ACA3FDC97F391E83DFD3F59D84735C483E73FEF63F65A4C2700406AF1598F4407FDBFB7273789D169F53FBFFA2B6E06DEF73F2DBAC3026D90FB3F3854EF18F58A0840C3CFE9D23CA1F93F138E522F291EF63F4AB22013B447DB3F0D6DCA830DA103406CBDA3D3A7DFF93F22A0ED06A753E9BF7933EDA1305AF23FD73B64CC2D3AD63FE69FDDFAFE6FEF3F330D4457784C0740C806E5B55E9BC03FBC86D42ED61500C06856F1060D3CF63FDF5DAFEF335DF0BFFA2ACCCD6EE300402A7618890634F23FD1814325B8BAE63F3D823BE527FDD7BF4508921432BBEC3F8D575A5A9CBDF93F0D7ADB5893E3FF3F6E2A5DC8952F0540A652433C7C5DFB3FFD232642BE8BE5BFB748A61C23BDF23F0D3A19BDA3B2E73F41B6D4180DBED83F17A75156FD5B084000C6581237960040FFCE7DBE2B70F73F6E37ABAE8940E73F358D3310A61DC13F38A14291C3FCFA3FE11124A4789A06403E5A2E449DABE2BFFE8563FED352FA3FBAFCB74A047DEC3FD68B25F5717903C0EEA79B9D6B92E23FBAA453198718F63F726D15FC01D5FF3F66AF74F3FB61DDBFEC2ED1864471F23F862F11A24E55F2BFA68DFD239114F63F662C76B1D25DEC3F302DF638922CFA3F35BFD8640660DC3F993C87DAEC33FB3FFF9B248E0CA4EDBF0DCCCFD5E4DBE93FA1118CD0AAC808C0CA31434CC1AEF43F72D6AE4AD97EF63FB1286E33C117FF3F4F1ECACFAD72B33F43DF6CE356B5F73F6ECA1215A56BFD3F6E68C7510502E73FC196CC48D232FDBF4BB61CB88D9DF43F99D9C5C38DDFEEBF3C8CC626CDDBE43FE840DC6CADE40640A8FB051B86B3F33F7E70E35DE5F8F93FEBAD0356710DFD3FB9097CCE8B2904C0272CDAAFBB580040CB36C4F9470BFBBF760E33EA5F01F83FCD941BA8D5F0E23F136E6A9C5136F53F22AC25462CA1B03FD22FCAA6D249CCBF110D3F746F23F93F621D6D4DA753D6BF6A4B93D34CFAE7BF589E31871359F63FF3141A2C4692F1BF5B9DC4C855F3B33F4BAC93185AC1FABFC07EF65FCE1FFE3F5CD96F6AAB23EEBF27423C57373CF63FB6D3ED90C219C2BF353E58594709F13FDDD3DB803FC901C05435FA9EE620F63FAF6D6BB79088FFBF77C913E9DEE5F53F25B3030146A7FEBFA5B6D71C433EE73FA3E9546C7688F83FC754C1B8B8F0F73FDCBE04726D63E33F41C23C6F181AEF3F82A5B00DB03205404D5394B3D77AF83F3133C7BDE99C0640CCCBB325D6BFE33FE39A24E80250FDBFB4DD51ACB577F33F3CD6765FA6BBE8BF5E9B2265F056FD3FCDBF955B0D19F63FDD0D4CF01BFEFC3F0F5BC356E84F89BF9CFB2E47652AEA3FF31C4D2B426CF4BFD39E286BE1B7F43FF01C90CA7012DFBF43738ED558E5CB3F378902C637E2F13F6803B14FF390F83F7EAE1AF1503CF53F660B223BCD6ED63F2BBCBFB0C36B01C027797DCE8CE5F93F3C0167561EE600C0968C43743700F43F9CF2149ED2AE07C00B0AF0198464F93F368402ACE7F9B13F2431409F5028FC3F00450B6CA595F4BF578ED48FA281F13F5E0B698E4E0EF63FE3050786E836F23FDEEC7E4F72E3F03F4D3CED0EB0C1F03F8CD86BB121C8F93F3F50763FB647E33FFDDF1773F69C07C0E102E4AFE869F03FAFCF8A629559F4BFC53B26D8305DF83F4CC50A284D520740B26BDE487221FA3F18E108F483B40740DC670E2C3122FB3FA67FDCA42D23CC3F642586501933FC3F5F7EAC2A347CF1BFEE01331D5B51D0BFAFFCD859040C07C07BDE9C1A2C35FD3FEEAB21EE604A05C0CA2A8E1F5E95FC3F8D4883440A67D8BF79959CC64C17E53F7DFF7574232FDDBFB1A5B8F94526F23F2C321B120DFBF3BF80AA66214DB0F93F1996165C4070FC3F8C032E2E6D6FF63F1B647E58559DF43F2BFFA830517DF13FE042CFB48CC2DCBF3E8E3E5AB5CDF63FCCEB8590FBD004C0D4BD85450E64913F723461B2201700C0DD7BD711D027EB3FE4E1243F34DDF63F14079F7882C0A6BFD4F84D382375F03F4D7BA7912278E13F658871E4ABB0C93F2226166D4430FC3F05AD71ECFD3ED23F078D82E3B10EFA3F1309F4F734E1DE3FF4790C46099AC5BF76DD112660F0DDBFAE55BC6A79F5FA3FD1E93E19388EFFBF3EFEBA2505B3F13F8A3E581C7653074096FC8852C876014055AB6BB0A8B5CA3FACBED66D97D1E83F991D9E903A030840CB3666AA1244F03F4990120D287C0540932485D28146F43FBEE06FD62BEFDABF1415B2F2565AFE3F1A6324AF53D2EA3F74CD61C44EBFF73FD849AF5B1475E8BF2D3C25FECE76FA3F7E53D2E76DD007C00B0BF0024C13FE3F8B9CF0643ADFC73F9B96E371A073E63F15CCA3C3EE8CD53FEE93996AA397EA3FB26EAA6F056DE23F566AB7FE1BE2F93F9894420C7A92F23FD9301D9278F0F73FE1BBA55478CFFBBFB78639FB9BCCF13F084DB48B98CC0440B26E0AF3625CE43FD5E29F676E22F5BFEC40816FE2EAFB3F56BB6E3FC7BFD4BF389145FFE9B3F13F1D3DDABDC3E7FD3F3E312460A94DF33F15FE216A636300C018E1A6C67C7CF63F2DC709ACF1C5EDBF9885350205AEF23FFFD33192381600400B5F16421DB9F63F174B15E56616E43F970C5B3CE7F8E93F32FC021D2185F43F62EFB4F606A5F83FAD3B4F62AB460440AC3799D3176AE53F83B7B4D0FD7D0440257AE1EFBE25FB3FEE726E0454F7F23FF7727D06D83DF83F2A38C875A1FCE03FBA5472FD2630F53FAB8D1665C0ACEF3FBC2154CED374FA3F98F29702C8B908401CF9E9077C81F63FCA01F4C55CADF33F0264772413E7F03FC4E1D6C414A6DDBF"> : tensor<20x20xcomplex<f64>>
    return %cst : tensor<20x20xcomplex<f64>>
  }
}