package com.hibernate.service;

import com.hibernate.entity.Post;
import com.hibernate.entity.PostContent;
import com.hibernate.entity.Tag;
import com.hibernate.entity.enums.ContentType;
import com.lowagie.text.Document;
import com.lowagie.text.Element;
import com.lowagie.text.Font;
import com.lowagie.text.Image;
import com.lowagie.text.PageSize;
import com.lowagie.text.Paragraph;
import com.lowagie.text.Phrase;
import com.lowagie.text.Rectangle;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;
import java.awt.Color;
import java.io.ByteArrayOutputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;
import javax.servlet.ServletContext;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class PostPdfServiceImpl implements PostPdfService {
    private static final Color PRIMARY = new Color(37, 99, 235);
    private static final Color LIGHT_BACKGROUND = new Color(248, 250, 252);
    private static final Color CODE_BACKGROUND = new Color(17, 24, 39);
    private static final Color BORDER = new Color(226, 232, 240);

    private final PostContentService postContentService;
    private final ServletContext servletContext;

    @Override
    public byte[] generatePostPdf(Post post) {
        try {
            ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
            Document document = new Document(PageSize.A4, 36, 36, 40, 40);
            PdfWriter.getInstance(document, outputStream);
            document.open();

            addHeader(document, post);
            addContents(document, post);

            document.close();
            return outputStream.toByteArray();
        } catch (Exception exception) {
            throw new IllegalStateException("Unable to generate post PDF.", exception);
        }
    }

    private void addHeader(Document document, Post post) throws Exception {
        Font titleFont = new Font(Font.HELVETICA, 24, Font.BOLD, new Color(15, 23, 42));
        Font metaFont = new Font(Font.HELVETICA, 10, Font.NORMAL, new Color(71, 85, 105));
        Font labelFont = new Font(Font.HELVETICA, 10, Font.BOLD, new Color(51, 65, 85));
        Font bodyFont = new Font(Font.HELVETICA, 11, Font.NORMAL, new Color(30, 41, 59));

        Paragraph title = new Paragraph(nullToEmpty(post.getTitle()), titleFont);
        title.setSpacingAfter(10);
        document.add(title);

        PdfPTable metaTable = new PdfPTable(2);
        metaTable.setWidthPercentage(100);
        metaTable.setWidths(new float[] {1, 3});
        addMetaRow(metaTable, "Category", post.getCategory() == null ? "-" : post.getCategory().getName(), labelFont, metaFont);
        addMetaRow(metaTable, "Author", post.getAuthor() == null ? "-" : post.getAuthor().getUsername(), labelFont, metaFont);
        addMetaRow(metaTable, "Status", String.valueOf(post.getStatus()), labelFont, metaFont);
        addMetaRow(metaTable, "Visibility", String.valueOf(post.getVisibility()), labelFont, metaFont);
        addMetaRow(metaTable, "Tags", getTagNames(post), labelFont, metaFont);
        metaTable.setSpacingAfter(14);
        document.add(metaTable);

        if (post.getExcerpt() != null && !post.getExcerpt().isBlank()) {
            Paragraph excerptTitle = new Paragraph("Excerpt", labelFont);
            excerptTitle.setSpacingAfter(4);
            document.add(excerptTitle);

            Paragraph excerpt = new Paragraph(post.getExcerpt(), bodyFont);
            excerpt.setSpacingAfter(16);
            document.add(excerpt);
        }
    }

    private void addMetaRow(PdfPTable table, String label, String value, Font labelFont, Font valueFont) {
        PdfPCell labelCell = new PdfPCell(new Phrase(label, labelFont));
        labelCell.setBorder(Rectangle.NO_BORDER);
        labelCell.setPadding(4);
        table.addCell(labelCell);

        PdfPCell valueCell = new PdfPCell(new Phrase(nullToEmpty(value), valueFont));
        valueCell.setBorder(Rectangle.NO_BORDER);
        valueCell.setPadding(4);
        table.addCell(valueCell);
    }

    private void addContents(Document document, Post post) throws Exception {
        List<PostContent> contents = postContentService.getContentsByPostId(post.getId());
        if (contents.isEmpty()) {
            return;
        }

        Paragraph heading = new Paragraph("Cheat Sheet Sections", new Font(Font.HELVETICA, 16, Font.BOLD, new Color(15, 23, 42)));
        heading.setSpacingAfter(10);
        document.add(heading);

        for (PostContent content : contents) {
            document.add(createSectionCard(content));
        }
    }

    private PdfPTable createSectionCard(PostContent content) throws Exception {
        PdfPTable table = new PdfPTable(1);
        table.setWidthPercentage(100);
        table.setSpacingAfter(12);

        String subtitle = content.getSubtitle() == null || content.getSubtitle().isBlank()
                ? "Untitled Section"
                : content.getSubtitle();
        PdfPCell header = new PdfPCell(new Phrase(subtitle + "  [" + content.getContentType() + "]",
                new Font(Font.HELVETICA, 12, Font.BOLD, Color.WHITE)));
        header.setBackgroundColor(PRIMARY);
        header.setBorderColor(PRIMARY);
        header.setPadding(9);
        table.addCell(header);

        PdfPCell body = new PdfPCell();
        body.setBackgroundColor(LIGHT_BACKGROUND);
        body.setBorderColor(BORDER);
        body.setPadding(10);

        addContentBody(body, content);
        table.addCell(body);
        return table;
    }

    private void addContentBody(PdfPCell body, PostContent content) throws Exception {
        String data = nullToEmpty(content.getContentData());
        ContentType contentType = content.getContentType() == null ? ContentType.TEXT : content.getContentType();

        if (ContentType.IMAGE.equals(contentType)) {
            Optional<Image> image = loadImage(data);
            if (image.isPresent()) {
                addScaledImage(body, image.get(), 470, 260);
                return;
            }

            body.addElement(new Paragraph("Image: " + data, bodyFont()));
            return;
        }

        if (ContentType.CODE.equals(contentType)) {
            body.setBackgroundColor(CODE_BACKGROUND);
            body.addElement(new Paragraph(data, new Font(Font.COURIER, 9, Font.NORMAL, Color.WHITE)));
            return;
        }

        if (ContentType.LINK.equals(contentType)) {
            body.addElement(new Paragraph(data, new Font(Font.HELVETICA, 10, Font.UNDERLINE, PRIMARY)));
            return;
        }

        body.addElement(new Paragraph(data, bodyFont()));
    }

    private Optional<Image> loadImage(String source) {
        if (source == null || source.isBlank()) {
            return Optional.empty();
        }

        try {
            String trimmed = source.trim();
            if (trimmed.startsWith("http://") || trimmed.startsWith("https://")) {
                return Optional.of(Image.getInstance(trimmed));
            }

            Optional<Path> localPath = resolveLocalPath(trimmed);
            if (localPath.isPresent()) {
                return Optional.of(Image.getInstance(localPath.get().toAbsolutePath().toString()));
            }
        } catch (Exception exception) {
            return Optional.empty();
        }

        return Optional.empty();
    }

    private Optional<Path> resolveLocalPath(String source) {
        if (source.startsWith("/uploads/posts/")) {
            Path persistentPath = Paths.get(
                    System.getProperty("user.home"),
                    "cheatsheet-uploads",
                    source.substring("/uploads/".length()))
                    .toAbsolutePath()
                    .normalize();
            if (Files.exists(persistentPath) && Files.isRegularFile(persistentPath)) {
                return Optional.of(persistentPath);
            }
        }

        if (source.startsWith("/")) {
            String webRoot = servletContext.getRealPath("/");
            if (webRoot != null) {
                Path webPath = Paths.get(webRoot, source.substring(1)).toAbsolutePath().normalize();
                if (Files.exists(webPath) && Files.isRegularFile(webPath)) {
                    return Optional.of(webPath);
                }
            }
        }

        Path directPath = Paths.get(source).toAbsolutePath().normalize();
        if (Files.exists(directPath) && Files.isRegularFile(directPath)) {
            return Optional.of(directPath);
        }

        return Optional.empty();
    }

    private void addScaledImage(PdfPCell cell, Image image, float maxWidth, float maxHeight) {
        image.scaleToFit(maxWidth, maxHeight);
        image.setAlignment(Element.ALIGN_LEFT);
        cell.addElement(image);
    }

    private String getTagNames(Post post) {
        if (post.getTags() == null || post.getTags().isEmpty()) {
            return "-";
        }

        return post.getTags().stream()
                .map(Tag::getName)
                .collect(Collectors.joining(", "));
    }

    private Font bodyFont() {
        return new Font(Font.HELVETICA, 10, Font.NORMAL, new Color(30, 41, 59));
    }

    private String nullToEmpty(String value) {
        return value == null ? "" : value;
    }
}
