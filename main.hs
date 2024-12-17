import Board
import Computer 
import Conecta4
import System.Directory (getModificationTime)
import Data.Time.Clock (UTCTime)
import Control.Monad.RWS (MonadState(put))

main :: IO ()
main = do
    lastModTime <- getModificationTime filePath

    -- Espera hasta que el archivo haya cambiado
    putStrLn "Esperando cambio en el archivo..."
    waitForFileChange lastModTime

    -- Leer tablero actual
    boardActual <- readBoard
    print boardActual
    putStrLn "Tablero leido"

    if haFinalizado boardActual
        then return ()
        else do
            -- Jugar IA

            putStrLn "Jugando IA..."
            let nuevoBoard = jugarIA 10 boardActual
            putStrLn "IA ha jugado"

            print nuevoBoard
            writeBoard nuevoBoard
            putStrLn "Tablero escrito"

            if haFinalizado nuevoBoard
                then return ()
                else do
                    main
