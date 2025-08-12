package com.example.tri_express

import android.view.KeyEvent
import com.example.tri_express.config.DefaultConfiguration
import com.example.tri_express.config.InventoryModeParams
import com.pda.uhf.UHFEngine
import com.pda.uhf.model.InventoryParams
import com.uhf.api.cls.ReadExceptionListener
import com.uhf.api.cls.ReadListener
import com.uhf.api.cls.Reader
import com.uhf.api.cls.Reader.READER_ERR
import com.uhf.api.cls.Reader.TagInfo
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.function.Consumer

class MainActivity : FlutterActivity() {
    private lateinit var methodChannel: MethodChannel
    private val CHANNEL = "com.example.tri_express/android_channel"
    private var isKeyDown = false
    private var isInventoryRunning = false

    val readListener: ReadListener = ReadListener { list: MutableList<TagInfo?>? ->
        if (list == null) return@ReadListener

        list.forEach(Consumer { tagInfo: TagInfo? ->
            if (tagInfo == null) return@Consumer

            val epcId = Reader.bytes_Hexstr(tagInfo.EpcId)
            val tidId = Reader.bytes_Hexstr(tagInfo.EmbededData)
            val frequency = tagInfo.Frequency
            val rssi = tagInfo.RSSI

            val args = mapOf("epc_id" to epcId, "tid_id" to tidId, "frequency" to frequency, "rssi" to rssi)
            methodChannel.invokeMethod("getTagInfo", args)
        })
    }

    val readErrorListener: ReadExceptionListener = ReadExceptionListener { err: READER_ERR? -> }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        methodChannel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
    }

    override fun onKeyDown(keyCode: Int, event: KeyEvent?): Boolean {
        if (!isKeyDown && (keyCode == 292 || keyCode == KeyEvent.KEYCODE_F1)) {
            if (isInventoryRunning) {
                // Then stop the inventory scan
                UHFEngine.getEngine().stopInventory()
                isInventoryRunning = false

                methodChannel.invokeMethod("endInventory", "Selesai")

            } else {
                // then start the inventory scan
                isKeyDown = true

                val params: InventoryParams? = InventoryModeParams.getParams(
                    DefaultConfiguration.inventoryMode,
                    DefaultConfiguration.inventoryParams,
                    DefaultConfiguration.isInventoryWithId
                )

                val er = UHFEngine.getEngine().startInventory(params, readListener, readErrorListener)

                if (er == READER_ERR.MT_OK_ERR) {
                    isInventoryRunning = true

                    methodChannel.invokeMethod("startInventory", "Mulai")
                }
            }
        }

        return super.onKeyDown(keyCode, event)
    }

    override fun onKeyUp(keyCode: Int, event: KeyEvent?): Boolean {
        if (isKeyDown && (keyCode == 292 || keyCode == KeyEvent.KEYCODE_F1)) {
            isKeyDown = false
        }

        return super.onKeyUp(keyCode, event)
    }

    override fun onResume() {
        super.onResume()
        UHFEngine.getEngine().powerOn()
        UHFEngine.getEngine().connectModule(DefaultConfiguration.UART_DEV_PATH, 1)
    }

    override fun onPause() {
        super.onPause()
        UHFEngine.getEngine().disconnectModule()
        UHFEngine.getEngine().powerOff()
    }
}
