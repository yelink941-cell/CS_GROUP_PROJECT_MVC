package com.hibernate.controller;

import com.hibernate.entity.User;
import com.hibernate.entity.UserNote;
import com.hibernate.service.UserNoteService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import javax.servlet.http.HttpSession;
import java.util.List;

@Controller
@RequestMapping("/notes")
@RequiredArgsConstructor
public class UserNoteController {

    private final UserNoteService userNoteService;

    // ─── Helper: session ထဲမှ current user ယူ ────────────────────
    private User getCurrentUser(HttpSession session) {
        return (User) session.getAttribute("currentUser");
    }

    // ─── GET /notes — Note list page ─────────────────────────────
    @GetMapping
    public String listNotes(HttpSession session, Model model) {
        User currentUser = getCurrentUser(session);
        if (currentUser == null) return "redirect:/login";

        List<UserNote> notes = userNoteService.getNotesByUser(currentUser.getId());
        model.addAttribute("notes", notes);
        return "notes/notes";
    }

    // ─── GET /notes/new — Create form ────────────────────────────
    @GetMapping("/new")
    public String showCreateForm(HttpSession session, Model model) {
        if (getCurrentUser(session) == null) return "redirect:/login";

        model.addAttribute("note", new UserNote());
        model.addAttribute("isEdit", false);
        return "notes/note-form";
    }

    // ─── GET /notes/{id}/edit — Edit form (Path Variable) ────────
    @GetMapping("/{id}/edit")
    public String showEditFormPath(
            @PathVariable("id") Integer id,
            HttpSession session,
            Model model,
            RedirectAttributes redirectAttrs) {
        return showEditFormInternal(id, session, model, redirectAttrs);
    }

    // ─── GET /notes/edit?id={id} — Legacy edit form ───────────────
    @GetMapping("/edit")
    public String showEditFormParam(
            @RequestParam("id") Integer id,
            HttpSession session,
            Model model,
            RedirectAttributes redirectAttrs) {
        return showEditFormInternal(id, session, model, redirectAttrs);
    }

    private String showEditFormInternal(Integer id, HttpSession session, Model model, RedirectAttributes redirectAttrs) {
        User currentUser = getCurrentUser(session);
        if (currentUser == null) return "redirect:/login";

        UserNote note = userNoteService.getNoteById(id, currentUser.getId());
        if (note == null) {
            redirectAttrs.addFlashAttribute("error", "Note not found or access denied.");
            return "redirect:/notes";
        }

        model.addAttribute("note", note);
        model.addAttribute("isEdit", true);
        return "notes/note-form";
    }

    // ─── POST /notes/{id}/update — Update existing note (Path Variable) ───
    @PostMapping("/{id}/update")
    public String updateNotePath(
            @PathVariable("id") Integer id,
            @ModelAttribute("note") UserNote note,
            HttpSession session,
            RedirectAttributes redirectAttrs) {

        User currentUser = getCurrentUser(session);
        if (currentUser == null) return "redirect:/login";

        try {
            note.setId(id);
            userNoteService.updateNote(note, currentUser.getId());
            redirectAttrs.addFlashAttribute("success", "Note updated successfully");
        } catch (Exception e) {
            redirectAttrs.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/notes";
    }

    // ─── POST /notes/save — Save (create or legacy update) ─────────
    @PostMapping("/save")
    public String saveNote(
            @ModelAttribute("note") UserNote note,
            HttpSession session,
            RedirectAttributes redirectAttrs) {

        User currentUser = getCurrentUser(session);
        if (currentUser == null) return "redirect:/login";

        try {
            if (note.getId() != null) {
                userNoteService.updateNote(note, currentUser.getId());
                redirectAttrs.addFlashAttribute("success", "Note updated successfully");
            } else {
                userNoteService.saveNote(note, currentUser.getId());
                redirectAttrs.addFlashAttribute("success", "Note saved successfully");
            }
        } catch (Exception e) {
            redirectAttrs.addFlashAttribute("error", e.getMessage());
        }

        return "redirect:/notes";
    }

    // ─── POST /notes/delete — Soft delete ────────────────────────
    @PostMapping("/delete")
    public String deleteNote(
            @RequestParam("id") Integer id,
            HttpSession session,
            RedirectAttributes redirectAttrs) {

        User currentUser = getCurrentUser(session);
        if (currentUser == null) return "redirect:/login";

        try {
            userNoteService.deleteNote(id, currentUser.getId());
            redirectAttrs.addFlashAttribute("success", "Note deleted successfully");
        } catch (Exception e) {
            redirectAttrs.addFlashAttribute("error", e.getMessage());
        }
        return "redirect:/notes";
    }
}
