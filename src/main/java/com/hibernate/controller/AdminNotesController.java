package com.hibernate.controller;

import com.hibernate.entity.User;
import com.hibernate.entity.UserNote;
import com.hibernate.entity.enums.Role;
import com.hibernate.service.UserNoteService;
import com.hibernate.service.UserService;
import javax.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.List;

@Controller
@RequiredArgsConstructor
@RequestMapping("/admin/users")
public class AdminNotesController {

    private final UserNoteService userNoteService;
    private final UserService userService;

    private boolean isAuthorizedAdmin(HttpSession session) {
        User currentUser = (User) session.getAttribute("currentUser");
        return currentUser != null && currentUser.isAdmin();
    }

    @GetMapping("/{userId}/notes")
    public String viewUserNotes(@PathVariable("userId") Long userId, Model model, HttpSession session) {
        if (!isAuthorizedAdmin(session)) {
            return "redirect:/login";
        }

        User targetUser = userService.getUserById(userId);
        if (targetUser == null) {
            return "redirect:/admin/users";
        }

        List<UserNote> notes = userNoteService.getAdminNotesForUser(userId);
        model.addAttribute("targetUser", targetUser);
        model.addAttribute("notes", notes);
        model.addAttribute("activeTab", "users");
        return "admin/user-notes";
    }

    @PostMapping("/{userId}/notes/add")
    public String addNote(@PathVariable("userId") Long userId,
                          @RequestParam("title") String title,
                          @RequestParam("content") String content,
                          HttpSession session,
                          RedirectAttributes redirectAttributes) {
        if (!isAuthorizedAdmin(session)) {
            return "redirect:/login";
        }

        User admin = (User) session.getAttribute("currentUser");
        try {
            userNoteService.saveAdminNote(admin.getId(), userId, title, content);
            redirectAttributes.addFlashAttribute("success", "Note added successfully.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error adding note: " + e.getMessage());
        }

        return "redirect:/admin/users/" + userId + "/notes";
    }

    @PostMapping("/{userId}/notes/{noteId}/edit")
    public String editNote(@PathVariable("userId") Long userId,
                           @PathVariable("noteId") Integer noteId,
                           @RequestParam("title") String title,
                           @RequestParam("content") String content,
                           HttpSession session,
                           RedirectAttributes redirectAttributes) {
        if (!isAuthorizedAdmin(session)) {
            return "redirect:/login";
        }

        User admin = (User) session.getAttribute("currentUser");
        boolean isSuperAdmin = Role.SUPER_ADMIN.equals(admin.getRole());

        try {
            userNoteService.editAdminNote(admin.getId(), noteId, title, content, isSuperAdmin);
            redirectAttributes.addFlashAttribute("success", "Note updated successfully.");
        } catch (SecurityException e) {
            redirectAttributes.addFlashAttribute("error", "Unauthorized: You can only edit notes you wrote.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error editing note: " + e.getMessage());
        }

        return "redirect:/admin/users/" + userId + "/notes";
    }

    @PostMapping("/{userId}/notes/{noteId}/delete")
    public String deleteNote(@PathVariable("userId") Long userId,
                             @PathVariable("noteId") Integer noteId,
                             HttpSession session,
                             RedirectAttributes redirectAttributes) {
        if (!isAuthorizedAdmin(session)) {
            return "redirect:/login";
        }

        User admin = (User) session.getAttribute("currentUser");
        boolean isSuperAdmin = Role.SUPER_ADMIN.equals(admin.getRole());

        try {
            userNoteService.deleteAdminNote(admin.getId(), noteId, isSuperAdmin);
            redirectAttributes.addFlashAttribute("success", "Note deleted successfully.");
        } catch (SecurityException e) {
            redirectAttributes.addFlashAttribute("error", "Unauthorized: You can only delete notes you wrote.");
        } catch (Exception e) {
            redirectAttributes.addFlashAttribute("error", "Error deleting note: " + e.getMessage());
        }

        return "redirect:/admin/users/" + userId + "/notes";
    }
}
