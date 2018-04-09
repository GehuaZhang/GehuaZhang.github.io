Attribute VB_Name = "Module1"
Function civ(S, K, T, R, Target)
high = 1
low = 0
Do While (high - low) > 0.00001
If PriceC(S, K, T, R, (high + low) / 2) > Target Then
high = (high + low) / 2
Else
low = (high + low) / 2
End If
Loop
civ = (high + low) / 2
End Function
Function piv(S, K, T, R, Target)
high = 1
low = 0
Do While (high - low) > 0.00001
If PriceP(S, K, T, R, (high + low) / 2) > Target Then
high = (high + low) / 2
Else
low = (high + low) / 2
End If
Loop
piv = (high + low) / 2
End Function
Function d1(S, K, T, R, V)
d1 = (Log(S / K) + (R * T) + (V ^ 2 * T / 2)) / (V * Sqr(T))
End Function
Function d2(S, K, T, R, V)
d2 = d1(S, K, T, R, V) - V * Sqr(T)
End Function
Function PriceC(S, K, T, R, V)
PriceC = S * Application.NormSDist(d1(S, K, T, R, V)) - K * Exp(-(R * T)) * Application.NormSDist(d2(S, K, T, R, V))
End Function
Function PriceP(S, K, T, R, V)
PriceP = K * Exp(-R * T) * Application.NormSDist(-d2(S, K, T, R, V)) - S * Application.NormSDist(-d1(S, K, T, R, V))
End Function
