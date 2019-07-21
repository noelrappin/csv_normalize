require_relative "../src/csv_normalizer"

RSpec.describe CsvNormalizer do

  it "normalizes the basic sample" do
    data = File.read("data/sample.csv")
    normalizer = CsvNormalizer.new(data)
    normalizer.normalize
    expect(normalizer.errors).to eq("")
    expect(normalizer.output.split("\n")).to eq(
      [
        "Timestamp,Address,ZIP,FullName,FooDuration,BarDuration,TotalDuration,Notes",
        "2011-04-01T14:00:00-04:00,\"123 4th St, Anywhere, AA\",94121,MONKEY ALBERTO,5012.123,5553.123,10565.246,I am the very model of a modern major general",
        "2014-03-12T03:00:00-04:00,\"Somewhere Else, In Another Time, BB\",00001,SUPERMAN ÜBERTAN,401012.123,5553.123,406565.24600000004,This is some Unicode right here. ü ¡! 😀",
        "2016-02-29T15:11:11-05:00,111 Ste. #123123123,01101,RÉSUMÉ RON,113012.123,5553.123,118565.24600000001,🏳️🏴🏳️🏴",
        "2011-01-01T03:00:01-05:00,\"This Is Not An Address, BusyTown, BT\",94121,MARY 1,5012.123,0.0,5012.123,I like Emoji! 🍏🍎😍",
        "2017-01-01T02:59:59-05:00,\"123 Gangnam Style Lives Here, Gangnam Town\",31403,ANTICIPATION OF UNICODE FAILURE,5012.123,5553.123,10565.246,I like Math Symbols! ≱≰⨌⊚",
        "2011-11-11T14:11:11-05:00,überTown,10001,PROMPT NEGOTIATOR,5012.123,5553.123,10565.246,\"I’m just gonna say, this is AMAZING. WHAT NEGOTIATIONS.\"",
        "2010-05-12T19:48:12-04:00,Høøük¡,01231,SLEEPER SERVICE,5012.123,5553.123,10565.246,2/1/22",
        "2012-10-06T01:31:11-04:00,\"Test Pattern Town, Test Pattern, TP\",00121,株式会社スタジオジブリ,5012.123,5553.123,10565.246,1:11:11.123",
        "2004-10-02T11:44:11-04:00,The Moon,00011,HERE WE GO,5012.123,5553.123,10565.246,"
      ])
  end

  it "normalizes with bad dates" do
    data = File.read("data/sample-with-bad-dates.csv")
    normalizer = CsvNormalizer.new(data)
    normalizer.normalize
    expect(normalizer.errors).to eq("Date parse error in row 2\nDate parse error in row 3\n")
    expect(normalizer.output.split("\n")).to eq(
      [
        "Timestamp,Address,ZIP,FullName,FooDuration,BarDuration,TotalDuration,Notes",
      ])
  end

  it "normalizes with broken utf" do
    data = File.read("data/sample-with-broken-utf8.csv")
    normalizer = CsvNormalizer.new(data)
    normalizer.normalize
    expect(normalizer.errors).to eq("")
    expect(normalizer.output.split("\n")).to eq(
      [
        "Timestamp,Address,ZIP,FullName,FooDuration,BarDuration,TotalDuration,Notes",
        "2011-04-01T14:00:00-04:00,\"123 4th St, Anywhere, AA\",94121,MONKEY ALBERTO,5012.123,5553.123,10565.246,I am the very model of a modern major general",
        "2014-03-12T03:00:00-04:00,\"Somewhere Else, In Another Time, BB\",00001,SUPERMAN ÜBERTAN,401012.123,5553.123,406565.24600000004,This is some Unicode right h�xxx ü ¡! 😀",
        "2016-02-29T15:11:11-05:00,111 Ste. #123123123,01101,RÉSUMÉ RON,113012.123,5553.123,118565.24600000001,🏳️🏴🏳️🏴",
        "2011-01-01T03:00:01-05:00,\"This Is Not An Address, BusyTown, BT\",94121,MARY 1,5012.123,0.0,5012.123,I like Emoji! 🍏🍎😍",
        "2017-01-01T02:59:59-05:00,\"123 Gangnam Style Lives Here, Gangnam Town\",31403,ANTICIPATION OF UNICODE FAILURE,5012.123,5553.123,10565.246,I like Math Symbols! ≱≰⨌⊚",
        "2011-11-11T14:11:11-05:00,überTown,10001,PROMPT NEGOTIATOR,5012.123,5553.123,10565.246,\"I’m just gonna say, this is AMAZING. WHAT NEGOTIATIONS.\"",
        "2010-05-12T19:48:12-04:00,Høøük¡,01231,SLEEPER SERVICE,5012.123,5553.123,10565.246,2/1/22",
        "2012-10-06T01:31:11-04:00,\"Test Pattern Town, Test Pattern, TP\",00121,株式会社スタジオジブリ,5012.123,5553.123,10565.246,1:11:11.123",
        "2004-10-02T11:44:11-04:00,The Moon,00011,HERE WE GO,5012.123,5553.123,10565.246,"
      ])
  end

end