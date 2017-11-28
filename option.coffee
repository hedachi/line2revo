class Controller
  @init = ->
    $ =>
      @change_item_type()
  @change_item_type = ->
    for i, option_name of DATA.weapon
      $tr = $('<tr/>')
      $tr.append $("<td>#{option_name}</td>")
      $tr.append $("<td><input class='radio_red' id='option_#{i}_need' checked='checked' name='option_#{i}' value='need' type='radio'/><label for='option_#{i}_need'/></td>")
      $tr.append $("<td><input class='radio_red' id='option_#{i}_ok' name='option_#{i}' value='ok' type='radio'/><label for='option_#{i}_ok'/></td>")
      $tr.append $("<td><input class='radio_red' id='option_#{i}_ng' name='option_#{i}' value='ng' type='radio'/><label for='option_#{i}_ng'/></td>")
      $('table#option_selector').append $tr

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
