(module BYTA GOVERNANCE
    @doc "Testing External Custom Smart Contracts Building Capabilities"

    (defcap GOVERNANCE ()
        @doc "Capability Enforcing Banana Admin"
        true
        
    )

    ;;Banana Account
    (defconst BANANA|US_KEY "free.User000c-Keyset")
    (defconst BANANA|US_NAME "Ѻ.CЭΞŸNGúůρhãmИΘÛ¢₳šШдìAÚwŚGýηЗПAÊУÔȘřŽÍζЗηmΔφDmcдΛъ₳tĂýăŮsПÞ$öœGθeBŽvąαÃfçл¢ĎĆď$şbsЦэΘNÄëÍĂνуãöž¥àZjÆůšÁœôñχŽâЩåτâн4μфAOçĎΓuЗŮnøЙãĚè6Дżîþż$цÑûρψŻïZÉλûæřΨeèÎígςeL")
    (defconst BANANA|US_KDA-NAME "k:50d6c59b21e5e6e55baecaa75a1007de37576bde12d8230dc82459cc01b9484b")

    (defconst BANANA|SC_KEY "free.User000d-Keyset")
    (defconst BANANA|SC_NAME "Ѻ.œâσzüştŒhłσćØTöõúoвþçЧлρËШđюλ2ÙPeжŘťȚŤtθËûrólþŘß₿øuŁdáNÎČȘřΦĘbχλΩĄ¢ц2ŹθõĐLcÑÁäăå₿ξЭжулxòΘηĂœŞÝUËcω∇ß$ωoñД7θÁяЯéEU¢CЮxÃэJĘčÎΠ£αöŮЖбlćшbăÙЦÎAдŃЭб$ĞцFδŃËúHãjÁÝàĘSt")
    (defconst BANANA|SC_KDA-NAME "k:163320715f95957d1a15ea664fa6bd46f4c59dbb804f793ae93662a4c90b3189")

    ;;Even though free.BANANA.BANANA|SC_NAME has mint roles for <JUICE-98c486052a51>,
    ;;only calls from within its Module, where the governer capability can be supplied, will function.
    (defun ClandestineMint (patron:string)
        (BASIS.DPTF|C_Mint patron "JUICE-98c486052a51" free.BANANA.BANANA|SC_NAME 100.0 false)
        ;(OUROBOROS.DPTF|CX_Transfer patron "JUICE-98c486052a51" free.BANANA.BANANA|SC_NAME patron 100.0)
    )
)
gas-payer-v1