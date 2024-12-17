module Computer (jugarIA) where

import Board
import Data.List (transpose)

-- | Representación de un árbol de movimientos posibles
data Arbol a = Nodo a [Arbol a] deriving Show

-- | Evalúa el estado del tablero desde la perspectiva del jugador.
-- | Devuelve un puntaje para el estado actual del tablero.
evaluar :: Int -> Tablero -> Int
evaluar jugador tablero
    | haGanado tablero = if esGanador jugador tablero then 1000 else -1000
    | otherwise =
        10 * contarSecuencias 3 jugador tablero
        + 5 * contarSecuencias 2 jugador tablero
        - 10 * contarSecuencias 3 (3 - jugador) tablero
        - 5 * contarSecuencias 2 (3 - jugador) tablero

-- | Verifica si el jugador dado ha ganado el tablero
esGanador :: Int -> Tablero -> Bool
esGanador jugador tablero = any (any (== jugador)) (filasGanadoras tablero)
  where filasGanadoras = concatMap getDiagonales . (:[]) . id

-- | Cuenta todas las secuencias de longitud n en el tablero para un jugador.
contarSecuencias :: Int -> Int -> Tablero -> Int
contarSecuencias n jugador tablero =
    sum [contarEnLinea n jugador linea | linea <- obtenerLineas tablero]

-- | Genera todas las líneas posibles del tablero (filas, columnas, diagonales).
obtenerLineas :: Tablero -> [[Int]]
obtenerLineas tablero = tablero ++ transpose tablero ++ getDiagonales tablero ++ getDiagonales (map reverse tablero)

-- | Cuenta secuencias consecutivas de n piezas en una línea.
contarEnLinea :: Int -> Int -> [Int] -> Int
contarEnLinea n jugador = length . filter (== replicate n jugador) . subsequencesDeLongitud n

-- | Genera todas las subsecuencias de longitud fija.
subsequencesDeLongitud :: Int -> [a] -> [[a]]
subsequencesDeLongitud n xs
    | length xs < n = []
    | otherwise = take n xs : subsequencesDeLongitud n (tail xs)

-- | Genera el árbol de movimientos posibles.
generarArbol :: Int -> Int -> Tablero -> Arbol Tablero
generarArbol _ 0 tablero = Nodo tablero []
generarArbol jugador profundidad tablero
    | haFinalizado tablero = Nodo tablero []
    | otherwise =
        Nodo tablero [generarArbol (3 - jugador) (profundidad - 1) (poner jugador col tablero)
                      | col <- [0..6], puedeJugar col tablero]

-- | Realiza el movimiento Minimax para seleccionar la mejor columna.
jugarIA :: Int -> Int -> Tablero -> Tablero
jugarIA jugador profundidad tablero =
    let arbol = generarArbol jugador profundidad tablero
        mejorMovimiento = snd $ minimax jugador arbol
    in poner jugador mejorMovimiento tablero

-- | Algoritmo Minimax para seleccionar el mejor movimiento.
minimax :: Int -> Arbol Tablero -> (Int, Int)
minimax jugador (Nodo tablero [])
    = (evaluar jugador tablero, -1)
minimax jugador (Nodo _ hijos)
    = let valores = [(fst (minimax (3 - jugador) hijo), idx) | (hijo, idx) <- zip hijos [0..]]
      in if jugador == 2
         then maximum valores -- Maximizar el puntaje del jugador 2
         else minimum valores -- Minimizar el puntaje del jugador 1

-- | Verifica si se puede jugar en una columna.
puedeJugar :: Int -> Tablero -> Bool
puedeJugar col tablero = any (== 0) (tablero !! col)