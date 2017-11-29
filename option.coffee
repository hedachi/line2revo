class Controller
  @SIMULATION_TIMES = 10000
  @init = ->
    $ =>
      @change_item_type()
      Controller.execute()
      #$('#run').click -> Controller.execute()
      $('input[type=radio]').on 'change', -> Controller.execute()
  @change_item_type = ->
    for i, option_name of DATA[$('select.item_type').val()]
      $tr = $('<tr/>')
      $tr.append $("<td>#{option_name}</td>")
      $tr.append $("<td><input class='radio_red' id='option_#{i}_need' name='option_#{i}' value='need' type='radio'/><label for='option_#{i}_need'/></td>")
      $tr.append $("<td><input checked='checked' class='radio_red' id='option_#{i}_ok' name='option_#{i}' value='ok' type='radio'/><label for='option_#{i}_ok'/></td>")
      $tr.append $("<td><input class='radio_red' id='option_#{i}_ng' name='option_#{i}' value='ng' type='radio'/><label for='option_#{i}_ng'/></td>")
      $('table#option_selector').append $tr
  @execute = ->
    item_type = $('select.item_type').val()
    conditions = {}
    for i, name of DATA[item_type]
      conditions[name] = $("input[name=option_#{i}]:checked").val()
    all_results = []
    success = 0
    for i in [0...@SIMULATION_TIMES]
      sim_results = _.sampleSize(DATA[item_type], 3)
      if @judge(item_type, conditions, sim_results)
        success++
      all_results.push sim_results
    @show_summary(success)
  @show_summary = (success) ->
    $('#simulation_times').text @SIMULATION_TIMES
    $('#success_percent').text success * 100 / @SIMULATION_TIMES
    $('#success_times').text success
  @judge  = (item_type, conditions, sim_results) ->
    for name, requirement of conditions
      if      requirement == 'need'
        unless sim_results.indexOf(name) > -1
          return false
      else if requirement == 'ok'
      else if requirement == 'ng'
        if sim_results.indexOf(name) > -1
          return false
      else
        throw "条件が不正です。"
    return true

Controller.init()

DATA = 
  weapon: [
    '攻撃速度増加率'
    'HP吸収率'
    '物理攻撃力'
    '魔法攻撃力'
    'クリティカル'
    'クリティカルダメージ増加率'
    '防御無視ダメージ'
    '命中'
    '貫通'
    'アデナ獲得量増加率'
    '経験値獲得量増加率'
  ]
  head: [
    'HP吸収率'
    '物理防御力'
    '魔法防御力'
    '状態異常抵抗率'
    '最大HP'
    '最大MP'
    'HP回復量'
    'MP回復量'
    '固定ダメージ減少'
    '回避'
    '貫通'
    'アデナ獲得量増加率'
    '経験値獲得量増加率'
  ]
