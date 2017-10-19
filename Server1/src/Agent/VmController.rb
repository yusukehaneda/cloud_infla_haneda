#################################################################
#								#
# VMを操作するプログラム By Kuroki				#
# Ver1.0							#
#								#
#################################################################

require 'json'
require 'fileutils'
require './ModifyXML.rb'

class VmController
	ORIGINALXML = "/var/kvm/xml/original.xml"
	NEWXMLPATH = "/var/kvm/xml/"
	ORIGINALDISK = "/var/kvm/disk/original"
	NEWDISKPATH = "/var/kvm/disk/"

	def initialize
	end

	def vmCreate(hash)
		puts "***** vmの作成開始 *****"
		newXML = NEWXMLPATH + hash["uuid"] + ".xml"
		xml = ModifyXML.new(ORIGINALXML, newXML)
		disksource = NEWDISKPATH + hash["uuid"]
		
		xml.setName(hash["uuid"])
		xml.setUuid(hash["uuid"])
		xml.setVcpu(hash["vcpu"])
		xml.setMemory(hash["memory"])
		xml.setDiskSource(disksource)

		puts "***** XML作成完了 *****"

		#オリジナルディスクからデータをコピーする
		puts "***** ディスクデータコピー開始 *****"
		newDisk = NEWDISKPATH + hash["uuid"]
		FileUtils.cp(ORIGINALDISK, newDisk)
		puts "***** ディスクデータコピー完了 *****"

		#定義ファイルを読み込み
		%x[ #{"virsh define " +  newXML} ]
		puts "***** 定義ファイル読み込み完了 *****"
		puts "***** vmの作成完了 *****"
		
	end

	def vmStart(hash)
		puts "***** vmを起動します。対象uuid : #{hash["uuid"]} *****"
		target = hash["uuid"]
		value = %x[ #{"virsh start " + target }]
		puts "***** vmを起動しました。対象uuid : #{hash["uuid"]} *****"
	end

	def vmStop(hash)
		puts "***** vmを停止します。対象uuid : #{hash["uuid"]} *****"
		target = hash["uuid"]
		value = %x[ #{"virsh shutdown " + target } ]
		puts "***** vmを停止しました。対象uuid : #{hash["uuid"]} *****"
	end

	def vmDestroy(hash)
		puts "***** vmを強制停止します。対象uuid : #{hash["uuid"]} *****"
		target = hash["uuid"]
		value = %x[ #{"virsh destroy " + target } ]
		puts "***** vmを強制停止しました。対象uuid : #{hash["uuid"]} *****"
	end

	def vmDelete(hash)
		puts "***** vmを削除します。対象uuid : #{hash["uuid"]} *****"
		target = hash["uuid"]
		value = %x[ #{"virsh undefine " + target } ]
		targetDisk = NEWDISKPATH + hash["uuid"]
		File.delete targetDisk
		targetFile = NEWXMLPATH + hash["uuid"] + ".xml"
		File.delete targetFile
		puts "***** vmを削除しました。対象uuid : #{hash["uuid"]} *****"
	end
end