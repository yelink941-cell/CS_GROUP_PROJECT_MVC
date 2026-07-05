package com.hibernate.service;

import com.hibernate.dto.CheatSheetReportDto;
import java.util.List;

public interface CheatSheetReportService {
    List<CheatSheetReportDto> getReportData();
    long getTotalCheatSheetsCount();
    byte[] generatePdfReport();
    byte[] generateExcelReport();
}
