import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const DelanceModule = buildModule("DelanceModule", (m) => {

    const freelancerAddress = "0x007Ada2aaAfD7021e8a4D6C3A748ECdAcE343Ee0";
    const deadline = 24*60*60

    const delance = m.contract("Delance", [freelancerAddress, deadline]);

    return { delance };
});

export default DelanceModule;
