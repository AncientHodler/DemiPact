-- Add these imports at the top of the file (if not already present)
import Data.Text (Text, pack)
import System.FilePath ((</>))
import Chainweb.Pact.Types (Transaction(..), ExecCmd(..), ModuleCode(..))
import Chainweb.Utils (readFileText)

-- Inside the function: genesisTransactions :: ChainId -> IO [Transaction]
genesisTransactions cid = do
    -- === YOUR 7 MASTER PUBLIC KEYS (replace with real ones!) ===
    let masterPubkeys :: [String]
        masterPubkeys =
          [ "1111111111111111111111111111111111111111111111111111111111111111"
          , "2222222222222222222222222222222222222222222222222222222222222222"
          , "3333333333333333333333333333333333333333333333333333333333333333"
          , "4444444444444444444444444444444444444444444444444444444444444444"
          , "5555555555555555555555555555555555555555555555555555555555555555"
          , "6666666666666666666666666666666666666666666666666666666666666666"
          , "7777777777777777777777777777777777777777777777777777777777777777"
          ]

    let masterNames :: [String]
        masterNames =
          [ "stoa-master-one"
          , "stoa-master-two"
          , "stoa-master-three"
          , "stoa-master-four"
          , "stoa-master-five"
          , "stoa-master-six"
          , "stoa-master-seven"
          ]

    -- 1. Create the namespace (admin = first master key for simplicity)
    let namespaceTx :: Transaction
        namespaceTx = mkExecTx $ ExecCmd $
          "(define-namespace 'stoa-ns \
          \  (read-keyset 'stoa-ns-admin-ks) \
          \  (read-keyset 'stoa-ns-admin-ks))"

    -- 2. Define a temporary admin keyset (just one of the masters)
    let adminKsTx :: Transaction
        adminKsTx = mkExecTx $ ExecCmd $
          "(define-keyset 'stoa-ns.stoa-ns-admin-ks \
          \  (keys-all [\"" ++ masterPubkeys !! 0 ++ "\"]))"

    -- 3. Define the 7 real master keysets
    let keysetTxs :: [Transaction]
        keysetTxs = zipWith (\name pk -> mkExecTx $ ExecCmd $ pack $
          "(define-keyset 'stoa-ns." ++ name ++ " \
          \  (keys-all [\"" ++ pk ++ "\"]))"
          ) masterNames masterPubkeys

    -- 4. Load and deploy your STOA module (adjust path if needed)
    stoaCode <- readFileText ("pact" </> "stoa.pact")  -- make sure file exists at this path
    let stoaModuleTx :: Transaction
        stoaModuleTx = mkDeployTx "STOA" (ModuleCode stoaCode)

    -- === Original genesis transactions (allocations, miners, etc.) ===
    originalTxs <- originalGenesisTransactions cid   -- this is whatever the function originally returned

    -- Final list: your stuff first, then the rest
    return $ [adminKsTx, namespaceTx] ++ keysetTxs ++ [stoaModuleTx] ++ originalTxs