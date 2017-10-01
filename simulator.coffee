class Simulator
  constructor: (plus) ->
    @plus = plus
  exec: (scroll_num) ->
    used_scroll_num = 0
    used_money = 0
    console.log "スクロール#{scroll_num}枚で、武器+#{@plus}を強化します。"
    loop 
      data = @constructor.get_data(@plus)
      used_scroll_num += data.scroll
      used_money += data.money
      if scroll_num - used_scroll_num >= 0
        before_plus = @plus
        is_success = (data.percent / 100) >= Math.random()
        if is_success
          result = '成功'
          @plus++
        else
          result = '失敗'
          unless @plus % 10 == 0 then @plus--
        console.log "+#{before_plus}からスクロール#{data.scroll}枚、#{data.money}アデナ、成功率#{data.percent}%で強化...[#{result}]#{@plus}になりました。"
      else
        console.log "スクロールが足りなくなりました。累計消費アデナ:#{used_money}"
        break
  @get_data = (plus) ->
    data = @DATA[plus]
    {
      percent: data[0]
      money: data[1]
      scroll: data[2]
      marble: data[3]
    }
  @DATA = [ #成功率,アデナ,消費スクロール数,消費マーブルの加護数
    [100,3400,1,0]
    [100,3400,1,0]
    [100,3400,1,0]
    [90,3400,1,1]
    [80,3400,1,1]
    [70,16700,2,2]
    [60,16700,2,2]
    [50,16700,2,3]
    [45,16700,2,3]
    [45,16700,2,4]
    [45,33400,3,4]
    [45,33400,3,5]
    [45,33400,3,5]
    [40,33400,3,6]
    [40,33400,3,6]
    [40,33400,4,7]
    [40,66700,4,7]
    [40,66700,4,8]
    [35,66700,4,8]
    [35,66700,4,9]
    [35,66700,5,9]
    [35,66700,5,10]
    [35,66700,5,10]
    [30,66700,5,11]
    [30,66700,5,11]
    [30,66700,6,12]
    [30,100000,6,12]
    [30,100000,6,13]
    [25,100000,6,13]
    [25,100000,6,14]
  ]

s = new Simulator(8)
s.exec(40)
#console.log s


