#mode of widget (light)
mode = "dark"

symbolList='GOOGL,INR=X,TATAMOTORS.NS,AAPL'


command: "curl -s 'https://query2.finance.yahoo.com/v7/finance/quote?symbols=#{symbolList}'"
#https://query2.finance.yahoo.com/v7/finance/quote?symbols=INR=X,VZ
refreshFrequency: '15m'

#=== DO NOT EDIT AFTER THIS LINE unless you know what you're doing! ===
#======================================================================

render: (output) -> """
  <div id='stocks' class='#{mode}'>#{output}</div>
"""

update: (output) ->
    financeQuoteData = JSON.parse(output)
    financeQuoteResults = financeQuoteData.quoteResponse.result
    console.log("financeQuoteResults -> ",financeQuoteResults)

    console.log("financeQuoteResults.length -> ", financeQuoteResults.length)
    
    inner = ""
    inner += "<header><img src='StockTicker.widget/icons/stocks.png'></img><div class='widgetName'>STOCKS</div></header>"

    inner += "<div class='stocksBox'>" 
    
    for i in [0...financeQuoteResults.length]
        displayName = financeQuoteResults[i].displayName
        symbol = financeQuoteResults[i].symbol
        shortName = financeQuoteResults[i].shortName
        regularMarketPrice = financeQuoteResults[i].regularMarketPrice
        change = (regularMarketPrice - financeQuoteResults[i].regularMarketPreviousClose).toFixed(2)
        if change > 0
          changeType = 'green';
          changeIcon= ''
        else 
          changeType = 'red';
          changeIcon= ''
        
        #console.log("displayName -> " + displayName)
        #console.log("symbol -> " + symbol)
        #console.log("shortName -> " +  shortName)
        #console.log("regularMarketPrice -> " + regularMarketPrice)
        inner += "
        <div class='columns'>
          <ul class='price'>
            <li class='header #{changeType}'>#{symbol}</li>
            <li>#{regularMarketPrice} (<span class='#{changeType}'>#{change} #{changeIcon}</span>)</li>
          </ul>
        </div>
        "
    inner += "</div>"
    console.log("inner ->\n", inner)
    $(stocks).html(inner)


style: """
    color: white
    font-family: SF Pro Rounded
    font-weight: 400
    width: 100%
    position: absolute
    top: calc(33% + 280px)
    font-size: 14px
    box-sizing: border-box
    
    #stocks
        border-radius: 10px
        background-color: rgba(0,0,0,0.45)
        -webkit-backdrop-filter: blur(20px)
        width: auto
        height: auto
        position: absolute
        
        bottom: 10px;
        //right: 10%;
        left: 50%;
    
        transform: translate(-50%,5%)
        padding: 40px 10px 10px 10px
        -webkit-box-shadow: 10px 10px 47px 0px rgba(0,0,0,0.54)
        letter-spacing: 1px

    #stocks.dark
        background-color: rgba(0,0,0,0.45)

    #stocks.light
        background-color: rgba(255,255,255,0.5)
        color: black

    #stocks.light header
        color: rgba(50,50,50,0.8)

    #stocks.dark header
        color: rgba(200,200,200,0.8)

    header 
        padding: 10px 0 10px 0
        display: flex
        flex-direction: row
        position: fixed
        top: 0
    
    header img
        width: 30px
        height: 30px
        margin-right: 10px

    header .widgetName
        line-height: 20px
    
    .stocksBox
        overflow-y: scroll
        height: 100%

    * {
      box-sizing: border-box;
    }

    .columns {
      float: left;
      width: 50%;
      padding: 8px;
    }

    .price {
      list-style-type: none;
      border: 1px solid tan;
      border-radius: 8px
      margin: 0;
      padding: 0;
      //-webkit-transition: 0.3s;
      //transition: 0.3s;
    }

    .price:hover {
      box-shadow: 0 8px 12px 0 rgba(0,0,0,0.2)
    }

    .price .header {
      background-color: #4CAF50;
      //background-color: coralblue;
      color: white;
      text-align: center;
      height: 25px
    }

    .price li {
      padding: 20px;
      text-align: center;
      border-radius: 5px;
    }

    .price .grey {
      background-color: #eee;
      font-size: 20px;
    }

    .button {
      background-color: #4CAF50;
      border: none;
      color: white;
      padding: 10px 25px;
      text-align: center;
      text-decoration: none;
      font-size: 18px;
    }

    .green {
      color: green;
      //background-color: green;
    }

    .red {
      color: red;
      //background-color: red;
    }

    @media only screen and (max-width: 600px) {
      .columns {
        width: 100%;
      }
    }
"""
