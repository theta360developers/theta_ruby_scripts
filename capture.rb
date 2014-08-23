require './lib/theta_initiator.rb'

ThetaInitiator.open do |initiator|

  # キャプチャ開始
  # [0,0]はストレージIDとキャプチャフォーマット
  # それぞれ0の時はデバイス側が判断する.
  puts "InitiateCapture call. transaction_id: #{initiator.next_transaction_id.to_s}"
  initiator.simple_operation(PTP_OC_InitiateCapture, [0,0])

  print "Capturing...\r"

  # ObjectAddedイベントの待機
  recv_pkt = initiator.wait_event PTP_EC_ObjectAdded  # 期待するevent_code指定は無ければチェックしない

  print "Object Added!\n  Event: #{recv_pkt.payload.to_hash.inspect}\n"

  # CaptureCompletedイベントの待機
  recv_pkt = initiator.wait_event

  print "Capture Completed!\n  Event: #{recv_pkt.payload.to_hash.inspect}\n"

end

