struct IGMPv2PacketRaw
    type::UInt8
    max_resp_time::UInt8
    checksum::UInt16
    group_address::UInt32
end
@assert sizeof(IGMPv2PacketRaw) == 8

const IGMP_MEMBERSHIP_QUERY = UInt8(0x11)
const IGMP_V1_MEMBERSHIP_REPORT = UInt8(0x12)
const IGMP_V2_MEMBERSHIP_REPORT = UInt8(0x16)
const IGMP_V3_MEMBERSHIP_REPORT = UInt8(0x22)
const IGMP_LEAVE_GROUP = UInt8(0x17)

struct IGMPv2Packet
    type::UInt8
    max_resp_time::UInt8
    group_address::IPv4
end

function decode_igmpv2(data::DenseVector{UInt8})
    p = Base.unsafe_convert(Ptr{UInt8}, data)
    GC.@preserve data begin
        rh = unsafe_load(convert(Ptr{IGMPv2PacketRaw}, p))
    end
    IGMPv2Packet(
        rh.type,
        rh.max_resp_time,
        IPv4(ntoh(rh.group_address))
    )
end
