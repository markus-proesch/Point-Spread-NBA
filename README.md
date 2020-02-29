# Point-Spread-NBA 

Want to win millions of dollars betting on sports? So did I, which is why I decided to try to build a predictive model that would estimate the point spread in regular season NBA games. If you don’t know what point-spread is, that is okay, if you don’t have a clue about basketball that is also okay too. It's simple, it is a Linear Regression model predicting the point spread and winner of any NBA regular season games and is based on in-game statistics form 2018-2019 season and 2019-2020 (up until February 1st). Here is the model:

Point spread = 0 + 1.454(Difference-Field Goal %) + 0.275(Difference-Three Point %) + 0.200(Difference-Free Throw %) + 0.286(Difference-Rebounds) + 0.478(Difference-Offensive Rebounds) + 0.068(Difference-Assists) + (-0.999)( Difference-Total Turnovers) + 0.265(Difference-FT attempts) + 0.352(Difference-3P attempts)


