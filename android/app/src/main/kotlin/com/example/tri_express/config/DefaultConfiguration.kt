package com.example.tri_express.config

import com.pda.uhf.UHFParamsOperator
import com.uhf.api.cls.Reader.AntPower
import com.uhf.api.cls.Reader.AntPowerConf
import com.uhf.api.cls.Reader.Region_Conf

object DefaultConfiguration {
    var writePower: Short = 3300
    var readPower: Short = 3300
    var inventoryMode: InventoryModeParams.Mode? = InventoryModeParams.Mode.MULTI_TAG_FAST
    var session: Int = InventoryModeParams.Session.SESSION_1
    var target: Int = InventoryModeParams.Target.A_2_B
    var region: Region_Conf = Region_Conf.RG_PRC
    var UART_DEV_PATH: String = "/dev/ttysWK0"
    var isInventoryWithId: Boolean = false
    var inventoryParams: Int =
        InventoryModeParams.MetaFlag.RSSI or InventoryModeParams.MetaFlag.FREQUENCY
    var rfMode: Int = InventoryModeParams.RF_MODE[9]!!
    var currentEpc: String = ""

    fun defaultInitModule() {
        // Set antenna power configuration
        val antPowerConf = AntPowerConf()
        antPowerConf.antcnt = 1 // Set number of antennas — PDA has only one antenna

        val antPower = AntPower()
        antPower.readPower = readPower // Read power — adjust as needed
        antPower.writePower = writePower // Write power — adjust as needed
        antPower.antid = 1 // Antenna 1 — PDA has only one antenna

        antPowerConf.Powers[0] = antPower // PDA has only one antenna

        // Get UHFParamsOperator instance
        val instance = UHFParamsOperator.getInstance()

        // Set antenna power configuration to instance
        instance.setAntPowerConf(antPowerConf)
        // Set Gen2 session
        instance.setGen2Session(session)
        // Set Gen2 target
        instance.setGen2Target(target)
        // Set region
        // Region_Conf.RG_NA = North America (902-928 Mhz)
        // Region_Conf.RG_PRC = China 1 (920-925 Mhz)
        // Region_Conf.RG_EU = Europe (865-867 Mhz)
        // Region_Conf.RG_OPEN = Full frequency band (840-960 Mhz)
        instance.setRegionConf(region)
        instance.setGen2TagEncoding(rfMode)
    }
}
