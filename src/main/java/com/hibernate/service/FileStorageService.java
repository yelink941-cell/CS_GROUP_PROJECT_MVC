package com.hibernate.service;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Locale;
import java.util.Set;
import java.util.UUID;

@Service
public class FileStorageService {

    private static final Set<String> ALLOWED_IMAGE_TYPES = Set.of(
            "image/jpeg", "image/png", "image/gif", "image/webp", "image/jpg"
    );
    private static final Set<String> ALLOWED_VIDEO_TYPES = Set.of(
            "video/mp4", "video/webm", "video/quicktime", "video/x-msvideo"
    );
    // Added Document and File MIME types (PDF, Office, Text, Archives, Audio)
    private static final Set<String> ALLOWED_DOC_TYPES = Set.of(
            "application/pdf",
            "application/msword",
            "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
            "application/vnd.ms-excel",
            "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet",
            "application/vnd.ms-powerpoint",
            "application/vnd.openxmlformats-officedocument.presentationml.presentation",
            "text/plain",
            "text/csv",
            "text/markdown",
            "application/rtf",
            "application/zip",
            "application/x-zip-compressed",
            "application/x-rar-compressed",
            "application/x-7z-compressed",
            "application/json",
            "application/xml",
            "text/xml",
            "audio/mpeg",
            "audio/mp3",
            "audio/wav",
            "audio/ogg"
    );

    private static final Set<String> ALLOWED_IMAGE_EXT = Set.of(".jpg", ".jpeg", ".png", ".gif", ".webp");
    private static final Set<String> ALLOWED_VIDEO_EXT = Set.of(".mp4", ".webm", ".mov", ".avi");
    // Added Document & File extensions
    private static final Set<String> ALLOWED_DOC_EXT = Set.of(
            ".pdf", ".doc", ".docx", ".xls", ".xlsx", ".ppt", ".pptx",
            ".txt", ".csv", ".md", ".rtf", ".json", ".xml",
            ".zip", ".rar", ".7z", ".tar", ".gz",
            ".mp3", ".wav", ".ogg", ".m4a"
    );

    private final Path uploadRoot;

    public FileStorageService() {
        this.uploadRoot = Paths.get(System.getProperty("user.home"), "cheatsheet-uploads", "chat");
    }

    public Path getUploadRoot() {
        return uploadRoot;
    }

    public String storeChatFile(Long conversationId, MultipartFile file) throws IOException {
        if (file == null || file.isEmpty()) {
            throw new IllegalArgumentException("Choose the files");
        }

        if (!isAllowedFile(file)) {
            throw new IllegalArgumentException("Selected file format is not supported. Please upload Images, Videos, PDFs, Office Documents, Text/Data files, Archives, or Audio.");
        }

        Path conversationDir = uploadRoot.resolve(String.valueOf(conversationId));
        Files.createDirectories(conversationDir);

        String originalName = file.getOriginalFilename() != null ? file.getOriginalFilename() : "file";
        String safeName = originalName.replaceAll("[^a-zA-Z0-9._-]", "_");
        String storedName = UUID.randomUUID() + "_" + safeName;
        Path target = conversationDir.resolve(storedName);

        file.transferTo(target.toFile());

        return "/media/chat/" + conversationId + "/" + storedName;
    }

    public Path resolveStoredFile(Long conversationId, String filename) {
        Path resolved = uploadRoot.resolve(String.valueOf(conversationId)).resolve(filename).normalize();
        if (!resolved.startsWith(uploadRoot)) {
            throw new SecurityException("Invalid file path");
        }
        return resolved;
    }

    public boolean isAllowedFile(MultipartFile file) {
        String contentType = file.getContentType();
        if (contentType != null) {
            String lowerType = contentType.toLowerCase(Locale.ROOT);
            if (ALLOWED_IMAGE_TYPES.contains(lowerType)
                    || ALLOWED_VIDEO_TYPES.contains(lowerType)
                    || ALLOWED_DOC_TYPES.contains(lowerType)) { // Added check here
                return true;
            }
        }

        String name = file.getOriginalFilename();
        if (name == null) {
            return false;
        }
        String lower = name.toLowerCase(Locale.ROOT);
        return ALLOWED_IMAGE_EXT.stream().anyMatch(lower::endsWith)
                || ALLOWED_VIDEO_EXT.stream().anyMatch(lower::endsWith)
                || ALLOWED_DOC_EXT.stream().anyMatch(lower::endsWith); // Added check here
    }

    public boolean isImage(String contentType, String fileUrl) {
        if (contentType != null && ALLOWED_IMAGE_TYPES.contains(contentType.toLowerCase(Locale.ROOT))) {
            return true;
        }
        if (fileUrl == null) {
            return false;
        }
        String lower = fileUrl.toLowerCase(Locale.ROOT);
        return ALLOWED_IMAGE_EXT.stream().anyMatch(lower::endsWith);
    }

    public boolean isVideo(String contentType, String fileUrl) {
        if (contentType != null && ALLOWED_VIDEO_TYPES.contains(contentType.toLowerCase(Locale.ROOT))) {
            return true;
        }
        if (fileUrl == null) {
            return false;
        }
        String lower = fileUrl.toLowerCase(Locale.ROOT);
        return ALLOWED_VIDEO_EXT.stream().anyMatch(lower::endsWith);
    }

    // Optional: Added helper method for document checking if you need it elsewhere
    public boolean isDocument(String contentType, String fileUrl) {
        if (contentType != null && ALLOWED_DOC_TYPES.contains(contentType.toLowerCase(Locale.ROOT))) {
            return true;
        }
        if (fileUrl == null) {
            return false;
        }
        String lower = fileUrl.toLowerCase(Locale.ROOT);
        return ALLOWED_DOC_EXT.stream().anyMatch(lower::endsWith);
    }
}