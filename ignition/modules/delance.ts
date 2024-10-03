import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const DelanceModule = buildModule("DelanceModule", (m) => {

    const delance = m.contract("Delance");

    return { delance };
});

export default DelanceModule;
