package com.hibernate.controller;

import com.hibernate.dto.CheatSheetReportDto;
import com.hibernate.entity.User;
import com.hibernate.service.CheatSheetReportService;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Collections;
import java.util.List;
import javax.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequiredArgsConstructor
@RequestMapping("/admin/reports/cheatsheet")
public class CheatSheetReportController {

    private final CheatSheetReportService cheatSheetReportService;

    private boolean isAuthorizedAdmin(HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        if (currentUser != null && currentUser.isAdmin()) {
            return true;
        }

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        if (auth != null && auth.isAuthenticated()) {
            return auth.getAuthorities().stream()
                    .anyMatch(a -> a.getAuthority().equalsIgnoreCase("ROLE_ADMIN")
                            || a.getAuthority().equalsIgnoreCase("ADMIN"));
        }
        return false;
    }

    @GetMapping
    public String viewCheatSheetReport(
            @RequestParam(value = "page", defaultValue = "1") int page,
            @RequestParam(value = "pageSize", defaultValue = "10") int pageSize,
            Model model,
            HttpSession session) {
        if (!isAuthorizedAdmin(session)) {
            return "redirect:/login";
        }

        List<CheatSheetReportDto> allData = cheatSheetReportService.getReportData();
        long totalCheatSheets = cheatSheetReportService.getTotalCheatSheetsCount();

        int totalItems = allData.size();
        if (pageSize <= 0) pageSize = 10;
        int totalPages = (int) Math.ceil((double) totalItems / pageSize);
        if (totalPages <= 0) totalPages = 1;
        if (page < 1) page = 1;
        if (page > totalPages) page = totalPages;

        int fromIndex = (page - 1) * pageSize;
        int toIndex = Math.min(fromIndex + pageSize, totalItems);

        List<CheatSheetReportDto> pagedData = (fromIndex < totalItems && fromIndex >= 0)
                ? allData.subList(fromIndex, toIndex)
                : Collections.emptyList();

        DateTimeFormatter dtf = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        String reportTime = LocalDateTime.now().format(dtf);

        model.addAttribute("reportData", pagedData);
        model.addAttribute("totalCheatSheets", totalCheatSheets);
        model.addAttribute("reportTime", reportTime);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("pageSize", pageSize);
        model.addAttribute("totalItems", totalItems);
        model.addAttribute("startItem", totalItems > 0 ? fromIndex + 1 : 0);
        model.addAttribute("endItem", toIndex);
        model.addAttribute("activeTab", "cheatsheet-report");

        return "admin/cheatsheet-report";
    }

    @GetMapping("/pdf")
    public ResponseEntity<?> downloadPdf(HttpSession session) {
        if (!isAuthorizedAdmin(session)) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Unauthorized access");
        }

        try {
            byte[] pdfBytes = cheatSheetReportService.generatePdfReport();
            return ResponseEntity.ok()
                    .contentType(MediaType.APPLICATION_PDF)
                    .contentLength(pdfBytes.length)
                    .header(HttpHeaders.CONTENT_DISPOSITION, "inline; filename=\"monthly_cheat_sheet_report.pdf\"")
                    .body(pdfBytes);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .contentType(MediaType.TEXT_PLAIN)
                    .body("PDF Generation Error: " + e.getMessage());
        }
    }

    @GetMapping("/excel")
    public ResponseEntity<?> downloadExcel(HttpSession session) {
        if (!isAuthorizedAdmin(session)) {
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("Unauthorized access");
        }

        try {
            byte[] excelBytes = cheatSheetReportService.generateExcelReport();
            return ResponseEntity.ok()
                    .contentType(MediaType.parseMediaType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"))
                    .contentLength(excelBytes.length)
                    .header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"monthly_cheat_sheet_report.xlsx\"")
                    .body(excelBytes);
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .contentType(MediaType.TEXT_PLAIN)
                    .body("Excel Generation Error: " + e.getMessage());
        }
    }
}
