Attribute VB_Name = "Ä£¿é1"
Function dOne(S, X, T, r, v, d)
 
dOne = (Log(S / X) + (r - d + 0.5 * v ^ 2) * T) / (v * (Sqr(T)))
 
End Function
 
Function NdOne(S, X, T, r, v, d)
 
NdOne = Exp(-(dOne(S, X, T, r, v, d) ^ 2) / 2) / (Sqr(2 * Application.WorksheetFunction.Pi()))
 
End Function
 
Function dTwo(S, X, T, r, v, d)
 
dTwo = dOne(S, X, T, r, v, d) - v * Sqr(T)
 
End Function
 
Function NdTwo(S, X, T, r, v, d)
 
NdTwo = Application.NormSDist(dTwo(S, X, T, r, v, d))
 
End Function
 
Function OptionPrice(OptionType, S, X, T, r, v, d)

If T = 0 Then
    If OptionType = "C" Then
        OptionPrice = Application.Max(S - X, 0)
    ElseIf OptionType = "P" Then
        OptionPrice = Application.Max(X - S, 0)
    End If
Else
    If OptionType = "C" Then
        OptionPrice = Exp(-d * T) * S * Application.NormSDist(dOne(S, X, T, r, v, d)) - X * Exp(-r * T) * Application.NormSDist(dOne(S, X, T, r, v, d) - v * Sqr(T))
    ElseIf OptionType = "P" Then
        OptionPrice = X * Exp(-r * T) * Application.NormSDist(-dTwo(S, X, T, r, v, d)) - Exp(-d * T) * S * Application.NormSDist(-dOne(S, X, T, r, v, d))
    End If
End If
 
End Function
 
Function OptionDelta(OptionType, S, X, T, r, v, d)
 
If T = 0 Then
    OptionDelta = 0
Else
    If OptionType = "C" Then
        OptionDelta = Application.NormSDist(dOne(S, X, T, r, v, d))
    ElseIf OptionType = "P" Then
        OptionDelta = Application.NormSDist(dOne(S, X, T, r, v, d)) - 1
    End If
End If

End Function
 
Function OptionTheta(OptionType, S, X, T, r, v, d)
 
If T = 0 Then
    OptionTheta = 0
Else
    If OptionType = "C" Then
        OptionTheta = -((S * v * NdOne(S, X, T, r, v, d)) / (2 * Sqr(T)) - r * X * Exp(-r * (T)) * NdTwo(S, X, T, r, v, d)) / 365
    ElseIf OptionType = "P" Then
        OptionTheta = -((S * v * NdOne(S, X, T, r, v, d)) / (2 * Sqr(T)) + r * X * Exp(-r * (T)) * (1 - NdTwo(S, X, T, r, v, d))) / 365
    End If
End If
 
End Function
 
Function OptionGamma(OptionType, S, X, T, r, v, d)
 
If T = 0 Then
    OptionGamma = 0
Else
    OptionGamma = NdOne(S, X, T, r, v, d) / (S * (v * Sqr(T)))
End If
 
End Function
 
Function OptionVega(OptionType, S, X, T, r, v, d)
 
If T = 0 Then
    OptionVega = 0
Else
    OptionVega = 0.01 * S * Sqr(T) * NdOne(S, X, T, r, v, d)
End If
 
End Function
 
Function OptionRho(OptionType, S, X, T, r, v, d)

If T = 0 Then
    OptionRho = 0
Else
    If OptionType = "C" Then
        OptionRho = 0.01 * X * T * Exp(-r * T) * Application.NormSDist(dTwo(S, X, T, r, v, d))
    ElseIf OptionType = "P" Then
        OptionRho = -0.01 * X * T * Exp(-r * T) * (1 - Application.NormSDist(dTwo(S, X, T, r, v, d)))
    End If
End If
 
End Function


