package com.hibernate.service;

import com.hibernate.dto.CheatSheetReportDto;
import com.hibernate.entity.Post;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;
import java.math.BigInteger;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import lombok.RequiredArgsConstructor;
import net.sf.jasperreports.engine.JasperCompileManager;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.data.JRMapCollectionDataSource;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.CellStyle;
import org.apache.poi.ss.usermodel.FillPatternType;
import org.apache.poi.ss.usermodel.Font;
import org.apache.poi.ss.usermodel.IndexedColors;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;
import org.hibernate.SessionFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class CheatSheetReportServiceImpl implements CheatSheetReportService {

    private final SessionFactory sessionFactory;

    @Override
    public List<CheatSheetReportDto> getReportData() {
        List<Object[]> results = sessionFactory.getCurrentSession()
                .createQuery(
                        "SELECT p, (SELECT COUNT(pl) FROM PostLike pl WHERE pl.post.id = p.id) "
                                + "FROM Post p LEFT JOIN FETCH p.author "
                                + "WHERE p.deletedAt IS NULL "
                                + "ORDER BY p.createdAt DESC",
                        Object[].class)
                .getResultList();

        long totalCount = results.size();
        List<CheatSheetReportDto> dtos = new ArrayList<>();
        int index = 1;

        for (Object[] row : results) {
            Post post = (Post) row[0];
            Long likeCount = (Long) row[1];

            String authorName = (post.getAuthor() != null)
                    ? post.getAuthor().getUsername()
                    : "Unknown";

            CheatSheetReportDto dto = CheatSheetReportDto.builder()
                    .no(BigInteger.valueOf(index++))
                    .author(authorName)
                    .created_date(post.getCreatedAt())
                    .title(post.getTitle())
                    .like_count(likeCount != null ? likeCount : 0L)
                    .total_cheat_sheets(totalCount)
                    .build();

            dtos.add(dto);
        }

        return dtos;
    }

    @Override
    public long getTotalCheatSheetsCount() {
        Long count = sessionFactory.getCurrentSession()
                .createQuery("SELECT COUNT(p) FROM Post p WHERE p.deletedAt IS NULL", Long.class)
                .uniqueResult();
        return count != null ? count : 0L;
    }

    private List<Map<String, ?>> prepareMapDataSource(List<CheatSheetReportDto> dataList) {
        List<Map<String, ?>> mapList = new ArrayList<>();
        for (CheatSheetReportDto dto : dataList) {
            Map<String, Object> map = new HashMap<>();
            map.put("no", dto.getNo());
            map.put("author", dto.getAuthor());
            map.put("title", dto.getTitle());
            map.put("created_date", dto.getFormattedCreatedDate());
            map.put("like_count", dto.getLike_count());
            map.put("total_cheat_sheets", dto.getTotal_cheat_sheets());
            mapList.add(map);
        }
        return mapList;
    }

    private InputStream getTemplateInputStream() throws Exception {
        InputStream inputStream = getClass().getResourceAsStream("/reports/monthly_cheat_sheet_report.jrxml");
        if (inputStream == null) {
            inputStream = getClass().getClassLoader().getResourceAsStream("reports/monthly_cheat_sheet_report.jrxml");
        }
        if (inputStream == null) {
            File file = new File("src/main/resources/reports/monthly_cheat_sheet_report.jrxml");
            if (file.exists()) {
                inputStream = new FileInputStream(file);
            }
        }
        if (inputStream == null) {
            File file = new File("src/test/resources/reports/monthly_cheat_sheet_report.jrxml");
            if (file.exists()) {
                inputStream = new FileInputStream(file);
            }
        }
        if (inputStream == null) {
            throw new IllegalStateException("Report template monthly_cheat_sheet_report.jrxml not found in classpath or resources.");
        }
        return inputStream;
    }

    @Override
    public byte[] generatePdfReport() {
        try (InputStream inputStream = getTemplateInputStream()) {
            List<CheatSheetReportDto> dataList = getReportData();
            List<Map<String, ?>> mapDataList = prepareMapDataSource(dataList);

            JasperReport jasperReport = JasperCompileManager.compileReport(inputStream);
            Map<String, Object> parameters = new HashMap<>();
            JRMapCollectionDataSource dataSource = new JRMapCollectionDataSource(mapDataList);

            JasperPrint jasperPrint = JasperFillManager.fillReport(jasperReport, parameters, dataSource);
            return JasperExportManager.exportReportToPdf(jasperPrint);
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Failed to generate PDF report: " + e.getMessage(), e);
        }
    }

    @Override
    public byte[] generateExcelReport() {
        try {
            List<CheatSheetReportDto> dataList = getReportData();

            try (Workbook workbook = new XSSFWorkbook(); ByteArrayOutputStream out = new ByteArrayOutputStream()) {
                Sheet sheet = workbook.createSheet("CheatSheet Report");

                // Header Style
                CellStyle headerStyle = workbook.createCellStyle();
                Font headerFont = workbook.createFont();
                headerFont.setBold(true);
                headerFont.setColor(IndexedColors.WHITE.getIndex());
                headerStyle.setFont(headerFont);
                headerStyle.setFillForegroundColor(IndexedColors.DARK_BLUE.getIndex());
                headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);

                String[] headers = {"NO", "CHEATSHEET NAME", "CREATED USER", "CREATED DATE", "REACTION COUNT"};
                Row headerRow = sheet.createRow(0);
                for (int i = 0; i < headers.length; i++) {
                    Cell cell = headerRow.createCell(i);
                    cell.setCellValue(headers[i]);
                    cell.setCellStyle(headerStyle);
                }

                DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
                int rowNum = 1;
                for (CheatSheetReportDto dto : dataList) {
                    Row row = sheet.createRow(rowNum++);
                    row.createCell(0).setCellValue(dto.getNo() != null ? dto.getNo().intValue() : rowNum - 1);
                    row.createCell(1).setCellValue(dto.getTitle() != null ? dto.getTitle() : "");
                    row.createCell(2).setCellValue(dto.getAuthor() != null ? dto.getAuthor() : "");
                    row.createCell(3).setCellValue(dto.getCreated_date() != null ? dto.getCreated_date().format(dtf) : "");
                    row.createCell(4).setCellValue(dto.getLike_count() != null ? dto.getLike_count() : 0);
                }

                for (int i = 0; i < headers.length; i++) {
                    sheet.autoSizeColumn(i);
                }

                workbook.write(out);
                return out.toByteArray();
            }
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Failed to generate Excel report: " + e.getMessage(), e);
        }
    }
}
