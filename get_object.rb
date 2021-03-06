require './lib/theta_initiator.rb'

ThetaInitiator.open do |initiator|
        
  # オブジェクトの列挙
  # 1つ目のパラメータはストレージID. 0xFFFFFFFFのときは全てのストレージから列挙
  # 2つめのパラメータはフォーマットID. 0xFFFFFFFFの時は全てのフォーマット.
  # 3つめのパラメータはオプション.場合によって異なるが、今回の全列挙の場合は0.
  response = initiator.operation(:GetObjectHandles, [0xFFFFFFFF, 0xFFFFFFFF, 0])
  offset = 0
  @object_handles, offset = PTP_parse_long_array(offset, response[:data])
  p @object_handles #オブジェクトハンドルのダンプ

  print "GetThumb...\n"
  # 最後に撮ったサムネイルの取得
  # 一番目のパラメータにObjectHandleを格納
  response = initiator.operation(:GetThumb, [@object_handles[-1]])
  File.open("./theta_thumb.jpg", "wb") do |f|
    f.write(response[:data].pack("C*"))
    print "Saved!\n"
  end

  print "GetObject...\n"
  # 最後に撮った写真の取得
  # 一番目のパラメータにObjectHandleを格納
  response = initiator.operation(:GetObject, [@object_handles[-1]])
  File.open("./theta_pic.jpg", "wb") do |f|
    f.write(response[:data].pack("C*"))
    print "Saved!\n"
  end

end

