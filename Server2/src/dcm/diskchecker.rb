######################################################
#
#dcmのプログラム By Haneda
# 実際の処理は[dcm.rb]にて行う 
# Ver 0.1
# 
#######################################################
#
#require './dcm.rb'

def diskcheck

  serve1 = `sshpass -p jiro ssh taro@192.168.0.101 df | grep /$ | awk '{ print \$4 }'`
  serve3 = `sshpass -p jiro ssh taro@192.168.0.103 df | grep /$ | awk '{ print \$4 }'`
  serve4 = `sshpass -p jiro ssh taro@192.168.0.104 df | grep /$ | awk '{ print \$4 }'`
 
  x = "serve1".to_i
  y = "serve3".to_i
  z = "serve4".to_i
  max = x
  max = y  if (y > max)
  max = z  if (z > max)
  result = max

   if result == serve1 then
     return "Server1"
   elsif result == serve3 then
     return "Server3"
   else  result == serve4
     return "Server4"
   end

end
#debug用
  #puts serve1,serve3,serve4  
  #puts result
  #
  #diskcheck