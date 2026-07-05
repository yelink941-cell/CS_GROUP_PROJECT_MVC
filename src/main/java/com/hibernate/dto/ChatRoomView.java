package com.hibernate.dto;

import java.time.LocalDateTime;

public class ChatRoomView {

    private Long conversationId;
    private String title;
    private Long partnerUserId;
    private String partnerRole;
    private boolean group;
    private boolean canModerate;
    private boolean blockedByMe;
    private boolean blockedByPartner;
    private boolean blockedEitherWay;

    private boolean partnerOnline;
    private LocalDateTime partnerLastSeen;
    private String partnerLastSeenFormatted;

    public Long getConversationId() { return conversationId; }
    public void setConversationId(Long conversationId) { this.conversationId = conversationId; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public Long getPartnerUserId() { return partnerUserId; }
    public void setPartnerUserId(Long partnerUserId) { this.partnerUserId = partnerUserId; }

    public String getPartnerRole() { return partnerRole; }
    public void setPartnerRole(String partnerRole) { this.partnerRole = partnerRole; }

    public boolean isGroup() { return group; }
    public void setGroup(boolean group) { this.group = group; }

    public boolean isCanModerate() { return canModerate; }
    public void setCanModerate(boolean canModerate) { this.canModerate = canModerate; }

    public boolean isBlockedByMe() { return blockedByMe; }
    public void setBlockedByMe(boolean blockedByMe) { this.blockedByMe = blockedByMe; }

    public boolean isBlockedByPartner() { return blockedByPartner; }
    public void setBlockedByPartner(boolean blockedByPartner) { this.blockedByPartner = blockedByPartner; }

    public boolean isBlockedEitherWay() { return blockedEitherWay; }
    public void setBlockedEitherWay(boolean blockedEitherWay) { this.blockedEitherWay = blockedEitherWay; }

    public boolean isPartnerOnline() { return partnerOnline; }
    public void setPartnerOnline(boolean partnerOnline) { this.partnerOnline = partnerOnline; }

    public LocalDateTime getPartnerLastSeen() { return partnerLastSeen; }
    public void setPartnerLastSeen(LocalDateTime partnerLastSeen) { this.partnerLastSeen = partnerLastSeen; }

    public String getPartnerLastSeenFormatted() { return partnerLastSeenFormatted; }
    public void setPartnerLastSeenFormatted(String partnerLastSeenFormatted) { this.partnerLastSeenFormatted = partnerLastSeenFormatted; }
}

