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

    // ─── GET /notes/edit?id={id} — Edit form ─────────────────────
    @GetMapping("/edit")
    public String showEditForm(
            @RequestParam("id") Integer id,
            HttpSession session,
            Model model,
            RedirectAttributes redirectAttrs) {

        User currentUser = getCurrentUser(session);
        if (currentUser == null) return "redirect:/login";

        UserNote note = userNoteService.getNoteById(id, currentUser.getId());
        if (note == null) {
            redirectAttrs.addFlashAttribute("error", "Note ကို ရှာမတွေ့ပါ သို့မဟုတ် ခွင့်မပြုပါ။");
            return "redirect:/notes";
        }

        model.addAttribute("note", note);
        model.addAttribute("isEdit", true);
        return "notes/note-form";
    }

    // ─── POST /notes/save — Save (create or update) ──────────────
    @PostMapping("/save")
    public String saveNote(
            @ModelAttribute("note") UserNote note,
            HttpSession session,
            RedirectAttributes redirectAttrs) {

        User currentUser = getCurrentUser(session);
        if (currentUser == null) return "redirect:/login";

        // Editing existing note — ownership check
        if (note.getId() != null) {
            UserNote existing = userNoteService.getNoteById(note.getId(), currentUser.getId());
            if (existing == null) {
                redirectAttrs.addFlashAttribute("error", "ခွင့်မပြုသောလုပ်ဆောင်ချက်ဖြစ်သည်။");
                return "redirect:/notes";
            }
            existing.setTitle(note.getTitle());
            existing.setContent(note.getContent());
            userNoteService.saveNote(existing, currentUser.getId());
        } else {
            userNoteService.saveNote(note, currentUser.getId());
        }

        redirectAttrs.addFlashAttribute("success", "Note သိမ်းဆည်းပြီးပါပြီ ✅");
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

        userNoteService.deleteNote(id, currentUser.getId());
        redirectAttrs.addFlashAttribute("success", "Note ဖျက်ပြီးပါပြီ 🗑️");
        return "redirect:/notes";
    }
}
