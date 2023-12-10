import SwiftUI
import CoreBluetooth


class PeripheralManager: NSObject, ObservableObject, CBPeripheralManagerDelegate {

    private var peripheralManager: CBPeripheralManager?
    @Published var peripheralManagerState: String! = ""
    //BLEで用いるサービス
    var service:CBMutableService?
    //BLEで用いるキャラクタリスティック：今回は全ての種類のCharacteristicを付与する
    //write属性のCharacteristic
    var writeCharacteristic:CBMutableCharacteristic?
    //writewithoutResponse属性のCharacteristic
    var writeWithoutResponseCharacteristic:CBMutableCharacteristic?
    //read属性のCharacteristic
    var readCharacteristic:CBMutableCharacteristic?
    //notify属性のCharacteristic
    var notifyCharacteristic:CBMutableCharacteristic?
    //indicate属性のCharacteristic
    var indicateCharacteristic:CBMutableCharacteristic?
    let BLEServiceUUID = CBUUID(string:"AAAAAAAA-BBBB-CCCC-DDDD-EEEEEEEEEEEE")

    // BLEで用いるキャラクタリスティック用のUUID
    let BLEWriteCharacteristicUUID = CBUUID(string:"AAAAAAAA-AAAA-BBBB-BBBB-BBBBBBBBBBBB")
    let BLEWriteWithoutResponseCharacteristicUUID = CBUUID(string:"AAAAAAAA-BBBB-BBBB-BBBB-BBBBBBBBBBBB")
    let BLEReadCharacteristicUUID = CBUUID(string:"AAAAAAAA-CCCC-BBBB-BBBB-BBBBBBBBBBBB")
    let BLENotifyCharacteristicUUID = CBUUID(string:"AAAAAAAA-DDDD-BBBB-BBBB-BBBBBBBBBBBB")
    let BLEIndicateCharacteristicUUID = CBUUID(string:"AAAAAAAA-EEEE-BBBB-BBBB-BBBBBBBBBBBB")

    override init() {
        super.init()
        peripheralManagerState = "none"
        setupPeripheralManager()
    }

    func setupPeripheralManager() {
        self.peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
    }

    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        peripheralManagerState = "Change peripheral states"
            if peripheral.state != .poweredOn {
                print("異常なStateのため処理を終了します\n")
                return;
            }
            addService()
    }

    func addService() {
        peripheralManagerState = "addService"
        // サービスの設定などを ViewController の addService メソッドから移植
        service = CBMutableService(type: BLEServiceUUID, primary: true)
                //キャラクタリスティックの設定(properties:属性、permissions：読み出し書込みの可否を与える)
        writeCharacteristic = CBMutableCharacteristic(type: BLEWriteCharacteristicUUID, properties: .write, value: nil, permissions: [.writeable,.readable])

        writeWithoutResponseCharacteristic = CBMutableCharacteristic(type: BLEWriteWithoutResponseCharacteristicUUID, properties: .writeWithoutResponse, value: nil, permissions: .writeable)

        //readCharacteristicは読み出した時の初期値を与えておくと、初期値固定になるのでnilにする
        //let readData = Data( [0x55])
        readCharacteristic = CBMutableCharacteristic(type: BLEReadCharacteristicUUID, properties: .read, value: nil, permissions: .readable)

        notifyCharacteristic = CBMutableCharacteristic(type: BLENotifyCharacteristicUUID, properties: .notify, value: nil, permissions: .readable)


        indicateCharacteristic = CBMutableCharacteristic(type: BLEIndicateCharacteristicUUID, properties: .indicate, value: nil, permissions: .readable)

        //サービスにキャラクタリスティックの設定
        service?.characteristics = [writeCharacteristic!,writeWithoutResponseCharacteristic!,readCharacteristic!,notifyCharacteristic!,indicateCharacteristic!]

        //ペリフェラルにサービスを追加
        peripheralManager?.add(service!)
    }

//④アドバタイズを開始
    func startAdvertising()
    {
        peripheralManagerState = "Start advertise"
        //アドバタイズに乗せるService
        let serviceUUIDs = [BLEServiceUUID]
        //アドバタイズデータのセット（LocalName:BLEの設定画面で表示される名称）
        let advertisementData:[String:Any] = [CBAdvertisementDataLocalNameKey: "TEST BLE"
                                 ,CBAdvertisementDataServiceUUIDsKey:serviceUUIDs]
        //アドバタイズ開始
        self.peripheralManager?.startAdvertising(advertisementData)
    }

    // アドバタイズを停止
    func stopAdvertising()
    {
        peripheralManagerState = "Stop advertise"
        self.peripheralManager?.stopAdvertising()
    }


    func indicate(){
        peripheralManagerState = "Start indicate"
        let indicateData = Data([0xBB])
        self.peripheralManager?.updateValue(indicateData, for: indicateCharacteristic!, onSubscribedCentrals: nil)

    }
    func notify(){
        peripheralManagerState = "Start notify"
        let notifyData = Data( [0xAA])
        peripheralManager?.updateValue(notifyData, for: notifyCharacteristic!, onSubscribedCentrals: nil)

    }
}


