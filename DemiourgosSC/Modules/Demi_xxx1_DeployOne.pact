;(namespace "n_e096dec549c18b706547e425df9ac0571ebd00b0")

;;A_SpawnAncientHodler
(TALOS|DALOS.A_DeployStandardAccount
    DEPLOYER.DEMIURGOI|AH_NAME
    (keyset-ref-guard DEPLOYER.DEMIURGOI|AH_KEY)
    DEPLOYER.DEMIURGOI|AH_KDA-NAME
    DEPLOYER.DEMIURGOI|AH_PBL
)

;;A_SpawnCTO
(TALOS|DALOS.A_DeployStandardAccount
    DEPLOYER.DEMIURGOI|CTO_NAME
    (keyset-ref-guard DEPLOYER.DEMIURGOI|CTO_KEY)
    DEPLOYER.DEMIURGOI|CTO_KDA-NAME
    DEPLOYER.DEMIURGOI|CTO_PBL
)

;;A_SpawnHOV
(TALOS|DALOS.A_DeployStandardAccount
    DEPLOYER.DEMIURGOI|HOV_NAME
    (keyset-ref-guard DEPLOYER.DEMIURGOI|HOV_KEY)
    DEPLOYER.DEMIURGOI|HOV_KDA-NAME
    DEPLOYER.DEMIURGOI|HOV_PBL
)

;;A_InitialiseDALOS-01
(BASIS.DefinePolicies)
(ATS.DefinePolicies)
(ATSI.DefinePolicies)
(TFT.DefinePolicies)
(ATSC.DefinePolicies)
(ATSH.DefinePolicies)
(ATSM.DefinePolicies)
(VESTING.DefinePolicies)
(LIQUID.DefinePolicies)
(OUROBOROS.DefinePolicies)
(BRANDING.DefinePolicies)

(TALOS|DALOS.DefinePolicies)
(TALOS|DPTF.DefinePolicies)
(TALOS|DPMF.DefinePolicies)
(TALOS|ATS1.DefinePolicies)
(TALOS|ATS2.DefinePolicies)
(TALOS|VST.DefinePolicies)
(TALOS|LIQUID.DefinePolicies)
(TALOS|OUROBOROS.DefinePolicies)

(DEPLOYER.DefinePolicies)

;;A_InitialiseDALOS-02
(with-capability (DEPLOYER.DEPLOYER-ADMIN)
    (let
        (
            (patron:string "Ѻ.éXødVțrřĄθ7ΛдUŒjeßćιiXTПЗÚĞqŸœÈэαLżØôćmч₱ęãΛě$êůáØCЗшõyĂźςÜãθΘзШË¥şEÈnxΞЗÚÏÛjDVЪжγÏŽнăъçùαìrпцДЖöŃȘâÿřh£1vĎO£κнβдłпČлÿáZiĐą8ÊHÂßĎЩmEBцÄĎвЙßÌ5Ï7ĘŘùrÑckeñëδšПχÌàî")
        )
        (TALOS|DALOS.A_DeploySmartAccount DEPLOYER.DALOS|SC_NAME (keyset-ref-guard DEPLOYER.DALOS|SC_KEY) DEPLOYER.DALOS|SC_KDA-NAME patron DEPLOYER.DALOS|PBL)
        ;; 
        (TALOS|DALOS.A_DeploySmartAccount DEPLOYER.ATS|SC_NAME (keyset-ref-guard DEPLOYER.ATS|SC_KEY) DEPLOYER.ATS|SC_KDA-NAME patron DEPLOYER.ATS|PBL)
        (ATS.ATS|SetGovernor patron)
        ;;
        (TALOS|DALOS.A_DeploySmartAccount DEPLOYER.VST|SC_NAME (keyset-ref-guard DEPLOYER.VST|SC_KEY) DEPLOYER.VST|SC_KDA-NAME patron DEPLOYER.VST|PBL)
        (VESTING.VST|SetGovernor patron)
        ;;    
        (TALOS|DALOS.A_DeploySmartAccount DEPLOYER.LIQUID|SC_NAME (keyset-ref-guard DEPLOYER.LIQUID|SC_KEY) DEPLOYER.LIQUID|SC_KDA-NAME patron DEPLOYER.LIQUID|PBL)
        (LIQUID.LIQUID|SetGovernor patron)
        ;;
        (TALOS|DALOS.A_DeploySmartAccount DEPLOYER.OUROBOROS|SC_NAME (keyset-ref-guard DEPLOYER.OUROBOROS|SC_KEY) DEPLOYER.OUROBOROS|SC_KDA-NAME patron DEPLOYER.OUROBOROS|PBL)
        (OUROBOROS.OUROBOROS|SetGovernor patron)
    )
)

;;A_InitialiseDALOS-03
(insert DALOS.DALOS|PropertiesTable DALOS.DALOS|INFO
    {"demiurgoi"                : 
        [
            DEPLOYER.DEMIURGOI|CTO_NAME
            DEPLOYER.DEMIURGOI|HOV_NAME
        ]
    ,"unity-id"                 : UTILS.BAR
    ,"gas-source-id"            : UTILS.BAR
    ,"gas-source-id-price"      : 0.0
    ,"gas-id"                   : UTILS.BAR
    ,"ats-gas-source-id"        : UTILS.BAR
    ,"elite-ats-gas-source-id"  : UTILS.BAR
    ,"wrapped-kda-id"           : UTILS.BAR
    ,"liquid-kda-id"            : UTILS.BAR}
)
;;Set Virtual Blockchain KDA Prices
(DALOS.DALOS|A_UpdateUsagePrice "standard"      10.0)
(DALOS.DALOS|A_UpdateUsagePrice "smart"         20.0)
(DALOS.DALOS|A_UpdateUsagePrice "dptf"         200.0)
(DALOS.DALOS|A_UpdateUsagePrice "dpmf"         300.0)
(DALOS.DALOS|A_UpdateUsagePrice "dpsf"         400.0)
(DALOS.DALOS|A_UpdateUsagePrice "dpnf"         500.0)
(DALOS.DALOS|A_UpdateUsagePrice "blue"          25.0)
;;Set Information in the DALOS|GasManagementTable
(insert DALOS.DALOS|GasManagementTable DALOS.DALOS|VGD
    {"virtual-gas-tank"         : DALOS.DALOS|SC_NAME
    ,"virtual-gas-toggle"       : false
    ,"virtual-gas-spent"        : 0.0
    ,"native-gas-toggle"        : false
    ,"native-gas-spent"         : 0.0}
)