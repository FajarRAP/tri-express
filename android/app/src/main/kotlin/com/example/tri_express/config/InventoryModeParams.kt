package com.example.tri_express.config

import com.pda.uhf.model.InventoryMode
import com.pda.uhf.model.InventoryParams
import com.uhf.api.cls.Reader

object InventoryModeParams {
    val RF_MODE: IntArray = intArrayOf(203, 111, 220, 101, 45, 115, 112, 103, 105, 107, 113)

    /*
    Retrieve configuration parameters based on different modes.
    mode: Mode selection — must be one of the predefined MODE enum values.
    isReadTid: Whether to read the TID (Tag Identifier) — only effective in NORMAL mode.
    */
    fun getParams(mode: Mode?, option: Int, isReadTid: Boolean): InventoryParams {
        val params = InventoryParams()
        params.ants = intArrayOf(1) // Only one antenna
        params.option = option
        params.timeout = 50

        // Default values
        params.smartMode = Reader.IT_MODE.IT_MODE_CT
        params.inventoryMode = InventoryMode.NORMAL
        params.isReadTid = false

        when (mode) {
            Mode.NORMAL -> params.isReadTid = isReadTid
            Mode.E7_NEW_FAST -> params.inventoryMode =
                InventoryMode.E7_NEW_FAST

            Mode.SINGLE_TAG -> params.inventoryMode =
                InventoryMode.SINGLE_TAG

            Mode.E7_READ_STOP -> {
                params.inventoryMode = InventoryMode.E7_READ_STOP
                params.smartMode = Reader.IT_MODE.IT_MODE_E7StopP
            }

            Mode.E7_SMART -> {
                params.inventoryMode = InventoryMode.E7_SMART
                params.smartMode = Reader.IT_MODE.IT_MODE_E7CT
            }

            Mode.MULTI_TAG_FAST -> params.inventoryMode =
                InventoryMode.MULTI_TAG_FAST

            else -> {}
        }

        return params
    }

    object Bank {
        val RESERVED: Byte = 0x00.toByte()
        val EPC: Byte = 0x01.toByte()
        val TID: Byte = 0x02.toByte()
        val USER: Byte = 0x03.toByte()
    }

    object MetaFlag {
        const val NOT_SETTING: Int = 0
        val RSSI: Int = 0X0002 shl 8
        val ANTENNA_ID: Int = 0X0004 shl 8
        val FREQUENCY: Int = 0X0008 shl 8
        val TIMESTAMP: Int = 0X0010 shl 8
        val RFU: Int = 0X0020 shl 8
        val PROTOCOL: Int = 0X0040 shl 8
        val EMD_DATA: Int = 0X0080 shl 8
    }

    object Session {
        const val SESSION_0: Int = 0
        const val SESSION_1: Int = 1
        const val SESSION_2: Int = 2
        const val SESSION_3: Int = 3
    }

    object Target {
        const val A: Int = 0
        const val B: Int = 1
        const val A_2_B: Int = 2
        const val B_2_A: Int = 3
    }

    enum class Mode {
        NORMAL,  // Normal mode
        E7_NEW_FAST,  // E7 high-speed mode
        SINGLE_TAG,  // Single tag mode
        E7_READ_STOP,  // E7 read-and-stop mode
        E7_SMART,  // E7 smart temperature control mode
        MULTI_TAG_FAST,  // Multi-tag high-speed mode
    }
}